fs = require 'fs'
{exec} = require 'child_process'
Solver = require './Solver'

classic =
  name: "Classic"
  rules: "classic"
  types:
    suspect: { title: "Suspects", preposition: "",      article: ""     }
    weapon:  { title: "Weapons",  preposition: "with ", article: "the " }
    room:    { title: "Rooms",    preposition: "in ",   article: "the " }
  cards:
    mustard:      { name: "Colonel Mustard", type: "suspect" }
    white:        { name: "Mrs. White",      type: "suspect" }
    plum:         { name: "Professor Plum",  type: "suspect" }
    peacock:      { name: "Mrs. Peacock",    type: "suspect" }
    green:        { name: "Mr. Green",       type: "suspect" }
    scarlet:      { name: "Miss Scarlet",    type: "suspect" }
    revolver:     { name: "Revolver",        type: "weapon"  }
    knife:        { name: "Knife",           type: "weapon"  }
    rope:         { name: "Rope",            type: "weapon"  }
    pipe:         { name: "Lead pipe",       type: "weapon"  }
    wrench:       { name: "Wrench",          type: "weapon"  }
    candlestick:  { name: "Candlestick",     type: "weapon"  }
    dining:       { name: "Dining Room",     type: "room"    }
    conservatory: { name: "Conservatory",    type: "room"    }
    kitchen:      { name: "Kitchen",         type: "room"    }
    study:        { name: "Study",           type: "room"    }
    library:      { name: "Library",         type: "room"    }
    billiard:     { name: "Billiards Room",  type: "room"    }
    lounge:       { name: "Lounge",          type: "room"    }
    ballroom:     { name: "Ballroom",        type: "room"    }
    hall:         { name: "Hall",            type: "room"    }
  suggestion: [ "suspect", "weapon", "room" ]



master_detective =
  name: "Master Detective"
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
  suggestion: [ "suspect", "weapon", "room" ]

haunted_mansion =
  name: "Haunted Mansion"
  rules: "classic"
  types:
    guest: { title: "Guests", preposition: "haunted ", article: ""     }
    ghost: { title: "Ghosts", preposition: "",         article: "the " }
    room:  { title: "Rooms",  preposition: "in ",      article: "the " }
  cards:
    pluto:        { name: "Pluto",            type: "guest" },
    daisy:        { name: "Daisy Duck",       type: "guest" },
    goofy:        { name: "Goofy",            type: "guest" },
    donald:       { name: "Donald Duck",      type: "guest" },
    minnie:       { name: "Minnie Mouse",     type: "guest" },
    mickey:       { name: "Mickey Mouse",     type: "guest" },
    prisoner:     { name: "Prisoner",         type: "ghost" },
    singer:       { name: "Opera Singer",     type: "ghost" },
    bride:        { name: "Bride",            type: "ghost" },
    traveler:     { name: "Traveler",         type: "ghost" },
    mariner:      { name: "Mariner",          type: "ghost" },
    skeleton:     { name: "Candlestick",      type: "ghost" },
    graveyard:    { name: "Graveyard",        type: "room"  },
    seance:       { name: "Seance Room",      type: "room"  },
    ballroom:     { name: "Ballroom",         type: "room"  },
    attic:        { name: "Attic",            type: "room"  },
    mausoleum:    { name: "Mausoleum",        type: "room"  },
    conservatory: { name: "Conservatory",     type: "room"  },
    library:      { name: "Library",          type: "room"  },
    foyer:        { name: "Foyer",            type: "room"  },
    chamber:      { name: "Portrait Chamber", type: "room"  },
  suggestion: [ "ghost", "guest", "room" ]

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
  inputFileName     = "./samples/1.js";
  outputFileName    = null;

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
#  console.log("Configuration: " + JSON.stringify(configuration, null, 2))

  input = (line for line in fs.readFileSync(inputFileName, { encoding: 'utf-8' }).split(/\r|\n/) when line.length > 0)

  # Load player list
  players = JSON.parse(input[0])
  input = input[1..]
#  console.log("Players: #{players}")

  suggestionId = 1
  solver = new Solver(configuration, players)
  while input.length > 0
    line = input[0]
    input = input[1..]

#    console.log("line: #{line}")
    step = JSON.parse(line)

    if step.show?
      s = step.show
      player = s.player
#      console.log("if not #{player?} or not #{solver.playerIsValid(player)}")
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
#      console.log("if not #{player?} or not #{solver.playerIsValid(player)}")
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
#      console.log("if not #{player?} or not #{solver.playerIsValid(player)}")
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
      console.log("   -> #{d}") for d in solver.discoveriesLog if solver.discoveriesLog.length > 0
#    console.log("if #{verbose} or #{solver.cardsThatMightBeHeldBy(solver.ANSWER_PLAYER_ID).length} == #{solver.types.length}")
    if verbose or solver.cardsThatMightBeHeldBy(solver.ANSWER_PLAYER_ID).length == 3
      console.log("ANSWER: #{solver.cardsThatMightBeHeldBy(solver.ANSWER_PLAYER_ID)}")

main()
