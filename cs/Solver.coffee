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
        held = c         # Assuming for now that none of the others are held
    return held

class Solver
  constructor: (configuration, playerIds) ->
    @ANSWER_PLAYER_ID = "ANSWER" # The answer is treated as a player
    @rulesId = configuration.rulesId
    @types = configuration.types
    @cards = {}
    @players = {}
    @discoveriesLog = []
    @suggestions = []
    @facts = []

#    console.log("configuration.cards = " + JSON.stringify(configuration.cards, null, 2))
    cardIds = (id for id, info of configuration.cards)
#    console.log("solver.cardIds = #{cardIds}")

    playerIdsIncludingAnswer = playerIds.concat(@ANSWER_PLAYER_ID)

    @cards[id] = new Card(playerIdsIncludingAnswer, info) for id, info of configuration.cards
    @players[p] = new Player(cardIds) for p in playerIdsIncludingAnswer
    @ANSWER = @players[@ANSWER_PLAYER_ID]
#    console.log("solver.players = " + JSON.stringify(@players, null, 2))

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
#    console.log("playerIsValid: return #{playerId} isnt #{@ANSWER_PLAYER_ID} and #{playerId} of #{@players}")
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
    #    If nobody showed a card, then none of the players (except possibly the suggester or the answer) have the cards.
    #    Only the last player in the showed list might hold any of the suggested cards.
    #    If the player that showed a card does not hold all but one of the cards, the player must hold the one.

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
    #    If a player shows a card but does not have all but one of the suggested cards, the player must hold the one.
    #    If a player (other than the answer and suggester) does not show a card, the player has none of the suggested cards.
    #    If all suggested cards are shown, then the answer and the suggester hold none of the suggested cards.

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
    potential = @ANSWER.potential[..]  # Must use a copy because the list of cards may be changed on the fly
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
      @addDiscovery(playerId, cardId, false) # Add this discovery, but don't log it 
    return changed

  disassociatePlayerWithCards: (playerId, cardIds, changed) ->
#    console.log("disassociatePlayerWithCards: (playerId: #{playerId}, cardIds: #{cardIds}, changed: #{changed}) ->")
    changed = @disassociatePlayerWithCard(playerId, id, changed) for id in cardIds
    return changed

  disassociateOtherPlayersWithCard: (playerId, cardId, changed) ->
    changed = @disassociatePlayerWithCard(otherId, cardId, changed) for otherId of @players when otherId isnt playerId
    return changed

  cardIsType: (cardId, type) ->
    return @cards[cardId].info.type is type

  addDiscovery: (playerId, cardId, holds, reason) ->
#    console.log("addDiscovery: (playerId: #{playerId}, cardId: #{cardId}, holds: #{holds}, reason: #{if reason? then reason else null})")
    # Check if the fact is not already known
#    console.log("addDiscovery: (playerId: #{playerId}, cardId: #{cardId}, holds: #{holds}, reason: #{if reason? then reason else null})")
    for f in @facts
      return if f.playerId is playerId and f.cardId is cardId

    fact = { playerId, cardId, holds }
#    console.log("addDiscovery: fact: #{JSON.stringify(fact)}")
    @facts.push(fact)
#    console.log("addDiscovery: facts length = #{@facts.length}")

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

export default Solver
