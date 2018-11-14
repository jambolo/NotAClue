`
import Solver from './Solver'
import TopBar from './TopBar'

import ConfirmDialog from './ConfirmDialog'
import CurrentState from './CurrentState'
import HandDialog from './HandDialog'
import MainMenu from './MainMenu'
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
  suggestion: [ "suspect", "weapon", "room" ]



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
  suggestion: [ "suspect", "weapon", "room" ]

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
  suggestion: [ "ghost", "guest", "room" ]

configurations =
  classic:          classic
  master_detective: master_detective
  haunted_mansion:  haunted_mansion

class App extends Component
  constructor: (props) ->
    super(props)
    @state =
      playerIds:          []
      configurationId:    "master_detective"
      solver:             null
      progress:           0
      mainMenuAnchor:     null
      handDialogOpen:     false
      suggestDialogOpen:  false
      showDialogOpen:     false
      newGameDialogOpen:  false
      confirmDialog:
        open:      false
        question:  ''
        yesAction: null
        noAction:  null

  newGame: (configurationId, playerIds) =>
    console.log("App::newGame(#{configurationId}, #{playerIds})")
    @setState({
      playerIds: playerIds
      configurationId: configurationId
      solver: new Solver(configurations[configurationId], playerIds)
      progress: 0
    })

  clearGame: =>
    console.log("App::clearGame")
    @setState({ solver: null, progress: 0 })

  recordHand: (playerId, cardsIds) =>
    console.log("App::recordHand(#{playerId}, [#{cardsIds}])")
    if @state.solver?
      @state.solver.hand(playerId, cardsIds) 
      @setState((state, props) -> { progress: state.progress+1 })

  recordSuggestion: (suggesterId, cardIds, showedIds) =>
    console.log("App::recordSuggestion(#{suggesterId}, [#{cardIds}], [#{showedIds}], #{@state.progress})")
    if @state.solver?
      @state.solver.suggest(suggesterId, cardIds, showedIds, @state.progress)
      @setState((state, props) -> { progress: state.progress+1 })

  recordShown: (playerId, cardId) =>
    console.log("App::recordShown(#{playerId}, #{cardId})")
    if @state.solver?
      @state.solver.show(playerId, cardId)
      @setState((state, props) -> { progress: state.progress+1 })

  showMainMenu: (anchor) ->
    @setState({ mainMenuAnchor: anchor })

  showHandDialog: =>
    @setState({ handDialogOpen: true })

  showSuggestDialog: =>
    @setState({ suggestDialogOpen: true })    

  showShowDialog: =>
    @setState({ showDialogOpen: true })

  handleShowDialogClose: =>
    @setState({ showDialogOpen: false })

  showNewGameDialog: =>
    @setState({ newGameDialogOpen: true })

  handleNewGameDialogClose: =>
    @setState({ newGameDialogOpen: false })

  showConfirmDialog: (question, yesAction, noAction) =>
    @setState({ confirmDialog: { open: true, question, yesAction, noAction } })

  handleConfirmDialogClose: =>
    @setState({ confirmDialog: { open: false, question: '', yesAction: null, noAction: null } })

  render: ->
    <div className="App">
      <TopBar
        app={this}
      />
      {<CurrentState solver={@state.solver} app={this} /> if @state.solver?}
      <MainMenu
        anchor={@state.mainMenuAnchor}
        onClose={() => @setState({ mainMenuAnchor: null })}
        app={this}
      />
      <SetupDialog
        open={@state.newGameDialogOpen}
        configurations={configurations}
        playerIds={@state.playerIds}
        configurationId={@state.configurationId}
        onClose={@handleNewGameDialogClose}
        app={this}
      />
      <HandDialog
        open={@state.handDialogOpen}
        configuration={configurations[@state.configurationId]}
        playerIds={@state.playerIds}
        onClose={() => @setState({ handDialogOpen: false })}
        app={this}
      />
      <SuggestDialog
        open={@state.suggestDialogOpen}
        configuration={configurations[@state.configurationId]}
        playerIds={@state.playerIds}
        onClose={() => @setState({ suggestDialogOpen: false })}
        app={this}
      />
      <ShowDialog
        open={@state.showDialogOpen}
        configuration={configurations[@state.configurationId]}
        playerIds={@state.playerIds}
        onClose={() => @setState({ showDialogOpen: false })}
        app={this}
      />
      <ConfirmDialog
        open={@state.confirmDialog.open}
        question={@state.confirmDialog.question}
        yesAction={@state.confirmDialog.yesAction}
        noAction={@state.confirmDialog.noAction}
        onClose={() => @setState({ confirmDialog: { open: false, question: '', yesAction: null, noAction: null } })}
        app={this}
      />
    </div>

export default App
