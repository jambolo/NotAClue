`
import Solver from './Solver'

import AccuseDialog from './AccuseDialog'
import CommlinkDialog from './CommlinkDialog'
import ConfirmDialog from './ConfirmDialog'
import ExportDialog from './ExportDialog'
import HandDialog from './HandDialog'
import ImportDialog from './ImportDialog'
import LogDialog from './LogDialog'
import MainMenu from './MainMenu'
import MainView from './MainView'
import React, { Component } from 'react';
import SetupDialog from './SetupDialog'
import ShowDialog from './ShowDialog'
import SuggestDialog from './SuggestDialog'
`

classic =
  name:       "Classic"
  rulesId:    "classic"
  minPlayers: 3
  maxPlayers: 6
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
  suggestionOrder: [ "suspect", "weapon", "room" ]

master_detective =
  name:       "Master Detective"
  rulesId :   "master"
  minPlayers: 3
  maxPlayers: 10
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
  suggestionOrder: [ "suspect", "weapon", "room" ]

haunted_mansion =
  name:       "Haunted Mansion"
  rulesId:    "classic"
  minPlayers: 3
  maxPlayers: 6
  types:
    guest: { title: "Guests", preposition: "haunted ", article: ""     }
    ghost: { title: "Ghosts", preposition: "",         article: "the " }
    room:  { title: "Rooms",  preposition: "in ",      article: "the " }
  cards:
    pluto:        { name: "Pluto",            type: "guest" }
    daisy:        { name: "Daisy Duck",       type: "guest" }
    goofy:        { name: "Goofy",            type: "guest" }
    donald:       { name: "Donald Duck",      type: "guest" }
    minnie:       { name: "Minnie Mouse",     type: "guest" }
    mickey:       { name: "Mickey Mouse",     type: "guest" }
    prisoner:     { name: "Prisoner",         type: "ghost" }
    singer:       { name: "Opera Singer",     type: "ghost" }
    bride:        { name: "Bride",            type: "ghost" }
    traveler:     { name: "Traveler",         type: "ghost" }
    mariner:      { name: "Mariner",          type: "ghost" }
    skeleton:     { name: "Candlestick",      type: "ghost" }
    graveyard:    { name: "Graveyard",        type: "room"  }
    seance:       { name: "Seance Room",      type: "room"  }
    ballroom:     { name: "Ballroom",         type: "room"  }
    attic:        { name: "Attic",            type: "room"  }
    mausoleum:    { name: "Mausoleum",        type: "room"  }
    conservatory: { name: "Conservatory",     type: "room"  }
    library:      { name: "Library",          type: "room"  }
    foyer:        { name: "Foyer",            type: "room"  }
    chamber:      { name: "Portrait Chamber", type: "room"  }
  suggestionOrder: [ "ghost", "guest", "room" ]

star_wars =
  name:       "Star Wars"
  rulesId:    "star_wars"
  minPlayers: 3
  maxPlayers: 6
  types:
    planet: { title: "Planets", preposition: "Darth Vader is targeting ", article: ""     }
    room:   { title: "Rooms",  preposition: ", the plans are in ",       article: "the " }
    ship:   { title: "Ships", preposition: ", and we can escape in ",    article: "a " }
  cards:
    alderaan:   { name: "Alderaan",               type: "planet" }
    bespin:     { name: "Bespin",                 type: "planet" }
    dagobah:    { name: "Dagobah",                type: "planet" }
    endor:      { name: "Endor",                  type: "planet" }
    tattoine:   { name: "Tatooine",               type: "planet" }
    yavin:      { name: "Yavin 4",                type: "planet" }
    millenium:  { name: "Millenium Falcon",       type: "ship"   }
    xwing:      { name: "X-Wing",                 type: "ship"   }
    ywing:      { name: "Y-Wing",                 type: "ship"   }
    tiefighter: { name: "Tie Fighter",            type: "ship"   }
    pod:        { name: "Escape Pod",             type: "ship"   }
    tiebomber:  { name: "Tie Bomber",             type: "ship"   }
    laser:      { name: "Laser Control Room",     type: "room"   }
    overbridge: { name: "Overbridge",             type: "room"   }
    docking:    { name: "Docking Bay",            type: "room"   }
    red:        { name: "Red Control Room",       type: "room"   }
    war:        { name: "War Room",               type: "room"   }
    detention:  { name: "Detention Block",        type: "room"   }
    throne:     { name: "Throne Room",            type: "room"   }
    trash:      { name: "Trash Compactor",        type: "room"   }
    tractor:    { name: "Tractor Beam Generator", type: "room"   }
  suggestionOrder: [ "planet", "room", "ship" ]

harry_potter =
  name:       "Harry Potter"
  rulesId:    "classic"
  minPlayers: 3
  maxPlayers: 6
  types:
    suspect: { title: "Suspects", preposition: "", article: ""     }
    item:    { title: "Items",    preposition: "with ",  article: "a " }
    room:    { title: "Rooms",    preposition: "in ",    article: "the " }
  cards:
    draco:       { name: "Draco Malfoy",              type: "suspect" }
    crabbe:      { name: "Crabbe & Doyle",            type: "suspect" }
    lucius:      { name: "Lucius Malfoy",             type: "suspect" }
    delores:     { name: "Delores Umbridge",          type: "suspect" }
    peter:       { name: "Peter Pettigrew",           type: "suspect" }
    bellatrix:   { name: "Bellatrix LeStrange",       type: "suspect" }
    draught:     { name: "Sleeping Draught",          type: "item"   }
    cabinet:     { name: "Vanishing Cabinet",         type: "item"   }
    portkey:     { name: "Portkey",                   type: "item"   }
    impedimenta: { name: "Impedienta",                type: "item"   }
    petrifus:    { name: "Petrifus Totalus",          type: "item"   }
    mandarke:    { name: "Mandrake",                  type: "item"   }
    hall:        { name: "Great Hall",                type: "room"   }
    hospital:    { name: "Hospital Wing",             type: "room"   }
    requirement: { name: "Room of Requirement",       type: "room"   }
    potions:     { name: "Potions ClassRoom",         type: "room"   }
    trophy:      { name: "Trophy Room",               type: "room"   }
    divination:  { name: "Divination Classroom",      type: "room"   }
    owlry:       { name: "Owlry",                     type: "room"   }
    library:     { name: "Library",                   type: "room"   }
    defense:     { name: "Defense Against Dark Arts", type: "room"   }
  suggestionOrder: [ "suspect", "item", "room" ]

configurations =
  classic:          classic
  master_detective: master_detective
  haunted_mansion:  haunted_mansion
  star_wars:        star_wars
  harry_potter:     harry_potter

class App extends Component
  constructor: (props) ->
    super(props)
    @solver =       null
    @accusationId = 1
    @commlinkId =   1
    @suggestionId = 1
    @state =
      playerIds:         []
      configurationId:   "master_detective"
      log:               []
      mainMenuAnchor:    null
      newGameDialogOpen: false
      logDialogOpen:     false
      confirmDialog:
        open:      false
        title:     ''
        question:  ''
        yesAction: null
        noAction:  null
      handDialogOpen:    false
      suggestDialogOpen: false
      showDialogOpen:    false
      accuseDialogOpen:  false
    return

  newGame: (configurationId, playerIds) ->
    @solver =       new Solver(configurations[configurationId], playerIds)
    @accusationId = 1
    @suggestionId = 1
    @setState({
      playerIds:       playerIds
      configurationId: configurationId
      log:             [@setupLogEntry(configurationId, playerIds)]
    })
    return

  importLog: (imported) ->
    importedLog = JSON.parse(imported)
    if importedLog.length == 0
      @solver = null
      return

    setup = importedLog[0].setup
    @newGame(setup.variation, setup.players)

    for entry in importedLog[1..]
      if entry.hand?
        { player, cards } = entry.hand
        @recordHand(player, cards)
      else if entry.suggest? 
        { suggester, cards, showed } = entry.suggest
        @recordSuggestion(suggester, cards, showed)
      else if entry.show?
        { player, card } = entry.show
        @recordShow(player, card)
      else if entry.accuse?
        { accuser, cards, outcome } = entry.accuse
        @recordAccusation(accuser, cards, outcome)
      else if entry.commlink? and setup.variation is "star_wars"
        { caller, receiver, cards, showed } = entry.commlink
        @recordCommlink(caller, receiver, cards, showed)
      else
        console.log("Imported unsupported log entry: #{JSON.stringify(entry)}")
    return

  setupLogEntry: (configurationId, playerIds) ->
    { 
      setup:
        variation: configurationId
        players:   playerIds
    }

  # Component launchers

  showMainMenu: (anchor) =>
    @setState({ mainMenuAnchor: anchor })
    return

  showNewGameDialog: =>
    @setState({ newGameDialogOpen: true })
    return

  showImportDialog: =>
    @setState({ importDialogOpen: true })
    return

  showLog: =>
    @setState({ logDialogOpen: true })
    return

  showExportDialog: =>
    @setState({ exportDialogOpen: true })
    return

  showConfirmDialog: (title, question, yesAction, noAction) =>
    @setState({ 
      confirmDialog: {
        open: true
        title
        question
        yesAction
        noAction
      }
    })
    return

  showHandDialog: =>
    @setState({ handDialogOpen: true })
    return

  showSuggestDialog: =>
    @setState({ suggestDialogOpen: true })    
    return

  showShowDialog: =>
    @setState({ showDialogOpen: true })
    return

  showAccuseDialog: =>
    @setState({ accuseDialogOpen: true })
    return

  showCommlinkDialog: =>
    @setState({ commlinkDialogOpen: true })
    return

  # Solver state updaters

  recordHand: (playerId, cardIds) ->
    if @solver?
      @solver.hand(playerId, cardIds) 
      @logHandEntry(playerId, cardIds)
    return

  logHandEntry: (playerId, cardIds) ->
    @setState((state, props) -> 
      { 
        log: state.log.concat([{
          hand:
            player: playerId
            cards:  cardIds
        }])
      }
    )
    return

  recordSuggestion: (suggesterId, cardIds, showedIds) ->
    if @solver?
      id = @suggestionId++
      @solver.suggest(suggesterId, cardIds, showedIds, id)
      @logSuggestEntry(suggesterId, cardIds, showedIds, id)
    return

  logSuggestEntry: (suggesterId, cardIds, showedIds, id) ->
    @setState((state, props) -> 
      { 
        log: state.log.concat([{
          suggest:
            id:        id
            suggester: suggesterId
            cards:     cardIds
            showed:    showedIds
        }])
      }
    )
    return

  recordShown: (playerId, cardId) ->
    if @solver?
      @solver.show(playerId, cardId)
      @logShowEntry(playerId, cardId)
    return

  logShowEntry: (playerId, cardId) ->
    @setState((state, props) -> 
      { 
        log: state.log.concat([{
          show:
              player: playerId
              card:   cardId
        }])
      }
    )
    return

  recordAccusation: (accuserId, cardIds, outcome) ->
    if @solver?
      id = @accusationId++
      @solver.accuse(accuserId, cardIds, outcome, id)
      @logAccuseEntry(accuserId, cardIds, outcome, id)
    return

  logAccuseEntry: (accuserId, cardIds, outcome, id) ->
    @setState((state, props) -> 
      { 
        log: state.log.concat([{
          accuse:
            id:      id
            accuser: accuserId
            cards:   cardIds
            outcome: outcome
        }])
      }
    )
    return

  recordCommlink: (callerId, receiverId, cardIds, showed) ->
    if @solver?
      id = @commlinkId++
      @solver.commlink(callerId, receiverId, cardIds, showed, id)
      @logCommlinkEntry(callerId, receiverId, cardIds, showed, id)
    return

  logCommlinkEntry: (callerId, receiverId, cardIds, showed, id) ->
    @setState((state, props) -> 
      { 
        log: state.log.concat([{
          commlink:
            id:       id
            caller:   callerId
            receiver: receiverId
            cards:    cardIds
            showed:   showed
        }])
      }
    )
    return

  render: ->
    <div className="App">
      <MainView configurationId={@state.configurationId} solver={@solver} app={this} />
      <MainMenu
        anchor={@state.mainMenuAnchor}
        started={@solver?}
        onClose={() => @setState({ mainMenuAnchor: null })}
        app={this}
      />
      <SetupDialog
        open={@state.newGameDialogOpen}
        configurations={configurations}
        onClose={() => @setState({ newGameDialogOpen: false })}
        app={this}
      />
      <ImportDialog
        open={@state.importDialogOpen}
        configurations={configurations}
        onClose={() => @setState({ importDialogOpen: false })}
        app={this}
      />
      <LogDialog
        open={@state.logDialogOpen}
        log={@state.log}
        configurations={configurations}
        onClose={() => @setState({ logDialogOpen: false })}
        app={this}
      />
      <ExportDialog
        open={@state.exportDialogOpen}
        log={@state.log}
        onClose={() => @setState({ exportDialogOpen: false })}
        app={this}
      />
      <ConfirmDialog
        open={@state.confirmDialog.open}
        title={@state.confirmDialog.title}
        question={@state.confirmDialog.question}
        yesAction={@state.confirmDialog.yesAction}
        noAction={@state.confirmDialog.noAction}
        onClose={@handleConfirmDialogClose}
        app={this}
      />
      <HandDialog
        open={@state.handDialogOpen}
        configuration={configurations[@state.configurationId]}
        players={@state.playerIds}
        onClose={() => @setState({ handDialogOpen: false })}
        app={this}
      />
      <SuggestDialog
        open={@state.suggestDialogOpen}
        configuration={configurations[@state.configurationId]}
        players={@state.playerIds}
        onClose={() => @setState({ suggestDialogOpen: false })}
        app={this}
      />
      <ShowDialog
        open={@state.showDialogOpen}
        configuration={configurations[@state.configurationId]}
        players={@state.playerIds}
        onClose={() => @setState({ showDialogOpen: false })}
        app={this}
      />
      <AccuseDialog
        open={@state.accuseDialogOpen}
        configuration={configurations[@state.configurationId]}
        players={@state.playerIds}
        onClose={() => @setState({ accuseDialogOpen: false })}
        app={this}
      />
      <CommlinkDialog
        open={@state.commlinkDialogOpen}
        configuration={configurations[@state.configurationId]}
        players={@state.playerIds}
        onClose={() => @setState({ commlinkDialogOpen: false })}
        app={this}
      />
    </div>

  # Callbacks
  
  handleConfirmDialogClose: =>
    @setState({ 
      confirmDialog: 
        open:      false
        title:     ""
        question:  ""
        yesAction: null
        noAction:  null 
    })
    return


export default App
