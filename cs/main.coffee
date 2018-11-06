fs = require 'fs'
{exec} = require 'child_process'

class Solver
    constructor: (configuration, playerIds) ->
        @ANSWER_PLAYER_ID = "ANSWER" # The answer is treated as a player
        @rulesId = configuration.rules
        @types = configuration.types
        @cards = {}
        @players = {}
        @discoveriesLog = []
        @suggestions = []
        @facts = []

#        console.log("configuration.cards = " + JSON.stringify(configuration.cards, null, 2))
        cardIds = (id for id, info of configuration.cards)
#        console.log("solver.cardIds = #{cardIds}")

        playerIdsIncludingAnswer = playerIds[..]
        playerIdsIncludingAnswer.push(@ANSWER_PLAYER_ID)

        @cards[id] = new Card(playerIdsIncludingAnswer, info) for id, info of configuration.cards
        @players[p] = new Player(cardIds) for p in playerIdsIncludingAnswer
        @ANSWER = @players[@ANSWER_PLAYER_ID]
#        console.log("solver.players = " + JSON.stringify(@players, null, 2))

    hand: (playerId, cardsIds) ->
        @discoveriesLog = []

        changed = false
        changed = @deduceFromHand(playerId, cardsIds, changed)
        changed = @makeOtherDeductions(changed)
        return changed

    show: (playerId, cardId) ->
        @discoveriesLog = []

        changed = false
        changed = @deduceFromShow(playerId, cardId, changed)
        changed = @makeOtherDeductions(changed)
        return changed

    suggest: (playerId, cardIds, showedIds, id) ->
        @discoveriesLog = []

        suggestion = { id, playerId, cardIds, showedIds }
        @suggestions.push(suggestion)

        changed = false
        changed = @deduceFromSuggestion(suggestion, changed)
        changed = @makeOtherDeductions(changed)
        return changed

    cardsThatMightBeHeldBy: (playerId) ->
        return @players[playerId].potential

    whoMightHold: (cardId) ->
        return @cards[cardId].holders

    playersAreValid: (playerIds) ->
        for p in playerIds
            return false if not @playerIsValid(p)
        return true

    playerIsValid: (playerId) ->
#        console.log("playerIsValid: return #{playerId} isnt #{@ANSWER_PLAYER_ID} and #{playerId} of #{@players}")
        return playerId isnt @ANSWER_PLAYER_ID and playerId of @players

    cardsAreValid: (cardIds) ->
        for c in cardIds
            return false if not @cardIsValid(c)
        return true

    cardIsValid: (cardId) ->
        return cardId of @cards

    typeIsValid: (typeId) ->
        return typeId in @types

    deduceFromSuggestion: (suggestion, changed) ->
        if @rulesId == "master"
            return @deduceFromSuggestionWithMasterRules(suggestion, changed)
        else
            return @deduceFromSuggestionWithClassicRules(suggestion, changed)

    # Make deductions based on the player having exactly these cards
    deduceFromHand: (playerId, hand, changed) ->
        # Associate the player with every card in the hand and disassociate the player with every other card.
        for cardId of @cards
            if cardId in hand
                @addDiscovery(playerId, cardId, true, "hand")
                changed = @associatePlayerWithCard(playerId, cardId, changed)
            else
                @addDiscovery(playerId, cardId, false, "hand")
                changed = @disassociatePlayerWithCard(playerId, cardId, changed)
        return changed
 
    # Make deductions based on the player having this cardId
    deduceFromShow: (playerId, cardId, changed) ->
        @addDiscovery(playerId, cardId, true, "revealed")
        changed = @associatePlayerWithCard(playerId, cardId, changed)
        return changed

    deduceFromSuggestionWithClassicRules: (suggestion, changed) ->
        id = suggestion.id
        suggesterId = suggestion.playerId
        cardIds = suggestion.cardIds
        showedIds = suggestion.showedIds

        # You can deduce from a suggestion that:
        #       If nobody showed a card, then none of the players (except possibly the suggester or the answer) have the cards.
        #       Only the last player in the showed list might hold any of the suggested cards.
        #       If the player that showed a card does not hold all but one of the cards, the player must hold the one.

        if showedIds is null or showedIds.length == 0
            for playerId of @players
                if playerId isnt @ANSWER_PLAYER_ID and playerId isnt suggesterId
                    @addDiscoveries(playerId, cardIds, false, "did not show a card in suggestion #" + id)
                    changed = @disassociatePlayerWithCards(playerId, cardIds, changed)
        else
            # All but the last player have none of the cards
            for i in [0...showedIds.length-1]
                playerId = showedIds[i]
                @addDiscoveries(playerId, cardIds, false, "did not show a card in suggestion #" + id)
                changed = @disassociatePlayerWithCards(playerId, cardIds, changed)

            # The last player showed a card.
            # If the player does not hold all but one of cards, the player must hold the one.
            playerId = showedIds[showedIds.length - 1]
            player = @players[playerId]
            mustHoldId = player.mustHoldOne(cardIds)
            if mustHoldId isnt null
                @addDiscovery(playerId, mustHoldId, true, "showed a card in suggestion #" + id + ", and does not hold the others")
                changed = @associatePlayerWithCard(playerId, mustHoldId, changed)
        return changed

    deduceFromSuggestionWithMasterRules: (suggestion, changed) ->
        id = suggestion.id
        suggesterId = suggestion.playerId
        cardIds = suggestion.cardIds
        showedIds = suggestion.showedIds

        # You can deduce from a suggestion that:
        #       If a player shows a card but does not have all but one of the suggested cards, the player must hold the one.
        #       If a player (other than the answer and suggester) does not show a card, the player has none of the suggested cards.
        #       If all suggested cards are shown, then the answer and the suggester hold none of the suggested cards.

        for playerId, player of @players

            # If the player showed a card ...
            if playerId in showedIds
                # ..., then if the player does not hold all but one of the cards, the player must hold the one.
                mustHoldId = player.mustHoldOne(cardIds)
                if mustHoldId isnt null
                    @addDiscovery(playerId, mustHoldId, true, "showed a card in suggestion #" + id + ", and does not hold the others")
                    changed = @associatePlayerWithCard(playerId, mustHoldId, changed)

            # Otherwise, if the player is other than the answer and suggester ...
            else if playerId isnt @ANSWER_PLAYER_ID and playerId isnt suggesterId
                # ... then they don't hold any of them.
                @addDiscoveries(playerId, cardIds, false, "did not show a card in suggestion #" + id)
                @disassociatePlayerWithCards(playerId, suggestion.cardIds, changed)

            # Otherwise, for the answer and suggester, if 3 cards were shown ...
            else
                if showedIds.length == 3
                    # ... then they don't hold them.
                    @addDiscoveries(playerId, cardIds, false, "all three cards were shown by other players in suggestion #" + id)
                    changed = @disassociatePlayerWithCards(playerId, cardIds, changed)
        return changed

    makeOtherDeductions: (changed) ->
        @addCardHoldersToDiscoveries()
        changed = @checkThatAnswerHoldsOnlyOneOfEach(changed)

        # While something has changed, then keep re-applying all the suggestions
        while (changed)
            changed = false
            changed = @deduceFromSuggestion(s, changed) for s in @suggestions
            @addCardHoldersToDiscoveries()
            changed = @checkThatAnswerHoldsOnlyOneOfEach(changed)

        @addCardHoldersToDiscoveries()
        return changed

    checkThatAnswerHoldsOnlyOneOfEach: (changed) ->
        answer = @players[@ANSWER_PLAYER_ID]

        # Find the cards that are known to be held by the answer
        heldByAnswer = {}
        for cardId in answer.potential
            card = @cards[cardId]
            heldByAnswer[card.info.type] = cardId if card.isHeldBy(@ANSWER_PLAYER_ID)

        # If so, then the answer can not hold any other cards of the same types
        potential = @ANSWER.potential[..]    # Must use a copy because the list of cards may be changed on the fly
        for cardId in potential
            card = @cards[cardId]
            for heldType, heldId of heldByAnswer
                if card.info.type is heldType and cardId isnt heldId
                    @addDiscovery(@ANSWER_PLAYER_ID, cardId, false, "ANSWER can only hold one " + heldType)
                    changed = @disassociatePlayerWithCard(@ANSWER_PLAYER_ID, cardId, changed)
        return changed

    associatePlayerWithCard: (playerId, cardId, changed) ->
        return changed if (@cards[cardId].holders.length == 1) # Already associated
        return @disassociateOtherPlayersWithCard(playerId, cardId, changed) # Simply remove all others as potential holders

    disassociatePlayerWithCard: (playerId, cardId, changed) ->
        player = @players[playerId]
        if player.mightHold(cardId)
            player.remove(cardId)
            @cards[cardId].remove(playerId)
            changed = true
            @addDiscovery(playerId, cardId, false)  # Add this discovery, but don't log it 
        return changed

    disassociatePlayerWithCards: (playerId, cardIds, changed) ->
#        console.log("disassociatePlayerWithCards: (playerId: #{playerId}, cardIds: #{cardIds}, changed: #{changed}) ->")
        changed = @disassociatePlayerWithCard(playerId, id, changed) for id in cardIds
        return changed

    disassociateOtherPlayersWithCard: (playerId, cardId, changed) ->
        changed = @disassociatePlayerWithCard(otherId, cardId, changed) for otherId of @players when otherId isnt playerId
        return changed

    cardIsType: (cardId, type) ->
        return @cards[cardId].info.type is type

    addDiscovery: (playerId, cardId, holds, reason) ->
#        console.log("addDiscovery: (playerId: #{playerId}, cardId: #{cardId}, holds: #{holds}, reason: #{if reason? then reason else null})")
        # Check if the fact is not already known
#        console.log("addDiscovery: (playerId: #{playerId}, cardId: #{cardId}, holds: #{holds}, reason: #{if reason? then reason else null})")
        for f in @facts
            return if f.playerId is playerId and f.cardId is cardId

        fact = { playerId, cardId, holds }
#        console.log("addDiscovery: fact: #{JSON.stringify(fact)}")
        @facts.push(fact)
#        console.log("addDiscovery: facts length = #{@facts.length}")

        if reason?
            cardInfo = @cards[cardId].info
            typeinfo = @types[cardInfo.type]
            discovery = playerId +
                (if holds then " holds " else " does not hold ") +
                typeinfo.article + 
                cardInfo.name +
                ": " +
                reason
            @discoveriesLog.push(discovery)

    addDiscoveries: (playerId, cardIds, holds, reason = null) ->
        @addDiscovery(playerId, c, holds, reason) for c in cardIds
        return

    addCardHoldersToDiscoveries: ->
        for cardId, card of @cards
            holders = card.holders
            @addDiscovery(holders[0], cardId, true, "nobody else holds it") if holders.length == 1

class Card
    constructor: (@holders, @info) ->

    remove: (playerId) ->
        @holders = @holders.filter (h) -> h isnt playerId

    mightBeHeldBy: (playerId) ->
        return playerId in @holders

    isHeldBy: (playerId) ->
        return @holders.length is 1 and @holders[0] is playerId

class Player
    constructor: (cardIds) ->
        @potential = cardIds

    remove: (cardId) ->
        @potential = @potential.filter (c) -> c isnt cardId


    mightHold: (cardId) ->
        return cardId in @potential

    mustHoldOne: (cardIds) ->
        count = 0
        held = null
        for c in cardIds
            if @mightHold(c)
                ++count
                return null if count > 1 # Early out -- might hold more than one, so no
                held = c                 # Assuming for now that none of the others are held
        return held





classic =
    rules: "classic"
    types:
        suspect: { title: "Suspects", preposition: "",      article: ""     }
        weapon:  { title: "Weapons",  preposition: "with ", article: "the " }
        room:    { title: "Rooms",    preposition: "in ",   article: "the " }
    cards:
        mustard:      { name: "Colonel Mustard", type:  "suspect" }
        white:        { name: "Mrs. White",      type:  "suspect" }
        plum:         { name: "Professor Plum",  type:  "suspect" }
        peacock:      { name: "Mrs. Peacock",    type:  "suspect" }
        green:        { name: "Mr. Green",       type:  "suspect" }
        scarlet:      { name: "Miss Scarlet",    type:  "suspect" }
        revolver:     { name: "Revolver",        type:  "weapon"  }
        knife:        { name: "Knife",           type:  "weapon"  }
        rope:         { name: "Rope",            type:  "weapon"  }
        pipe:         { name: "Lead pipe",       type:  "weapon"  }
        wrench:       { name: "Wrench",          type:  "weapon"  }
        candlestick:  { name: "Candlestick",     type:  "weapon"  }
        dining:       { name: "Dining Room",     type:  "room"    }
        conservatory: { name: "Conservatory",    type:  "room"    }
        kitchen:      { name: "Kitchen",         type:  "room"    }
        study:        { name: "Study",           type:  "room"    }
        library:      { name: "Library",         type:  "room"    }
        billiard:     { name: "Billiards Room",  type:  "room"    }
        lounge:       { name: "Lounge",          type:  "room"    }
        ballroom:     { name: "Ballroom",        type:  "room"    }
        hall:         { name: "Hall",            type:  "room"    }



master_detective =
    rules : "master"
    types :
        suspect: { title: "Suspects", preposition: "",      article: ""     }
        weapon:  { title: "Weapons",  preposition: "with ", article: "the " }
        room:    { title: "Rooms",    preposition: "in ",   article: "the " }
    cards :
        mustard:      { name: "Colonel Mustard",   type: "suspect" }
        white:        { name: "Mrs. White",        type: "suspect" }
        plum:         { name: "Professor Plum",    type: "suspect" }
        peacock:      { name: "Mrs. Peacock",      type: "suspect" }
        green:        { name: "Mr. Green",         type: "suspect" }
        scarlet:      { name: "Miss Scarlet",      type: "suspect" }
        rose:         { name: "Madame Rose",       type: "suspect" }
        gray:         { name: "Sergeant Gray",     type: "suspect" }
        brunette:     { name: "Monsieur Brunette", type: "suspect" }
        peach:        { name: "Miss Peach",        type: "suspect" }
        revolver:     { name: "Revolver",          type: "weapon"  }
        knife:        { name: "Knife",             type: "weapon"  }
        rope:         { name: "Rope",              type: "weapon"  }
        pipe:         { name: "Pipe",              type: "weapon"  }
        wrench:       { name: "Wrench",            type: "weapon"  }
        candlestick:  { name: "Candlestick",       type: "weapon"  }
        poison:       { name: "Poison",            type: "weapon"  }
        horseshoe:    { name: "Horseshoe",         type: "weapon"  }
        dining:       { name: "Dining Room",       type: "room"    }
        conservatory: { name: "Conservatory",      type: "room"    }
        kitchen:      { name: "Kitchen",           type: "room"    }
        studio:       { name: "Studio",            type: "room"    }
        library:      { name: "Library",           type: "room"    }
        billiard:     { name: "Billiard Room",     type: "room"    }
        courtyard:    { name: "Courtyard",         type: "room"    }
        gazebo:       { name: "Gazebo",            type: "room"    }
        drawing:      { name: "Drawing Room",      type: "room"    }
        carriage:     { name: "Carriage House",    type: "room"    }
        trophy:       { name: "Trophy Room",       type: "room"    }
        fountain:     { name: "Fountain",          type: "room"    }


configuration = master_detective
verbose = false

printSuggestion = (suggestionId, playerId, cardIds, results) ->
    suggestion = ""
    for c in cardIds
        cardInfo = configuration.cards[c]
        typeInfo = configuration.types[cardInfo.type]
        suggestion += " " + typeInfo.preposition + typeInfo.article + cardInfo.name

    prefix = if suggestionId < 10 then "( " else "("
    resultsString = if results.length > 0 then "#{results}" else "nobody"
    console.log(prefix + "#{suggestionId}) #{playerId} suggested#{suggestion} ==> #{resultsString}")

printShow = (playerId, cardId) ->
    cardInfo = configuration.cards[cardId]
    typeInfo = configuration.types[cardInfo.type]
    console.log("---- #{playerId} showed #{typeInfo.article} #{cardInfo.name}")

printHand = (playerId, cardIds) ->
    console.log("**** " + playerId + "'s hand: #{cardIds}")

loadConfiguration = (filename) ->
    json = fs.readFileSync(filename, { encoding: 'utf-8' })
    return JSON.parse(json)

main = () ->

    configurationFileName = null;
    inputFileName         = "./samples/1.js";
    outputFileName        = null;

    args = process.argv[2..]
    while args.length > 0
        arg = args[0]
        args = args[1..]
        if arg[0] == '-'
            switch arg[1]
                when 'c'
                    if args.length > 0
                        configurationFileName = args[0];
                        args = args[1..]
                when 'o'
                    if args.length > 0
                        outputFileName = args[0];
                        args = args[1..]
        else
            if (!inputFileName)
                inputFileName = arg;

    # Load configuration
    if configurationFileName isnt null
        configuration = loadConfiguration(configurationFileName)
#    console.log("Configuration: " + JSON.stringify(configuration, null, 2))

    input = (line for line in fs.readFileSync(inputFileName, { encoding: 'utf-8' }).split(/\r|\n/) when line.length > 0)

    # Load player list
    players = JSON.parse(input[0])
    input = input[1..]
#    console.log("Players: #{players}")

    suggestionId = 1
    solver = new Solver(configuration, players)
    while input.length > 0
        line = input[0]
        input = input[1..]

#        console.log("line: #{line}")
        step = JSON.parse(line)

        if step.show?
            s = step.show
            player = s.player
#            console.log("if not #{player?} or not #{solver.playerIsValid(player)}")
            if not player? or not solver.playerIsValid(player)
                throw "Invalid player: #{player}"
            card = s.card
            if not card? or not solver.cardIsValid(card)
                throw "Invalid card: #{card}"
            printShow(player, card)
            solver.show(player, card)
        else if step.suggest?
            s = step.suggest
            player = s.player
#            console.log("if not #{player?} or not #{solver.playerIsValid(player)}")
            if not player? or not solver.playerIsValid(player)
                throw "Invalid player: #{player}"
            cards = s.cards
            if not cards? or not solver.cardsAreValid(cards)
                throw "Invalid cards: #{cards}"
            showed = s.showed
            if not showed? or not solver.playersAreValid(showed)
                throw "Invalid players: #{players}"
            printSuggestion(suggestionId, player, cards, showed)
            solver.suggest(player, cards, showed, suggestionId)
            ++suggestionId
        else if step.hand?
            h = step.hand
            player = h.player
#            console.log("if not #{player?} or not #{solver.playerIsValid(player)}")
            if not player? or not solver.playerIsValid(player)
                throw "Invalid player: #{player}"
            cards = h.cards
            if not cards? or not solver.cardsAreValid(cards)
                throw "Invalid hand: #{hand}"
            printHand(player, cards)
            solver.hand(player, cards)
        else
            throw "Invalid step type: " + JSON.stringify(step, null, 2)

        if verbose
            console.log("     -> #{d}") for d in solver.discoveriesLog if solver.discoveriesLog.length > 0
#        console.log("if #{verbose} or #{solver.cardsThatMightBeHeldBy(solver.ANSWER_PLAYER_ID).length} == #{solver.types.length}")
        if verbose or solver.cardsThatMightBeHeldBy(solver.ANSWER_PLAYER_ID).length == 3
            console.log("ANSWER: #{solver.cardsThatMightBeHeldBy(solver.ANSWER_PLAYER_ID)}")

main()
