`
import React, { Component } from 'react';
import CssBaseline from '@material-ui/core/CssBaseline';

import Solver from './Solver'

import TopBar from './TopBar'
`

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

class App extends Component
  constructor: (props) ->
    super(props)
    @state =
      players: []
      configuration: "master_detective"
      solver: null
      progress: 0

    @configurations =
      classic:          classic
      master_detective: master_detective
      haunted_mansion:  haunted_mansion

  addPlayer: (player) =>
    @setState({ players: @state.players.concat([player]) })

  clearPlayers: () =>
    @setState({ players: [] } )

  setVersion: (version) =>
    @setState({ version: version } )

  newGame: () =>
    @setState({ solver: new Solver(@configurations[@state.version], @state.players), progress: 0 })

  cancelGame: () =>
    @setState( { solver: null, progress: 0 })

  hand: (playerId, cardsIds) =>
    if @state.solver?
      @state.solver.hand(playerId, cardsIds) 
      @setState({ progress: @state.progress+1 })
  show: (playerId, cardId) =>
    if @state.solver?
      @state.solver.show(playerId, cardId)
      @setState({ progress: @state.progress+1 })

  suggest: (playerId, cardIds, showedIds, progress) =>
    if @state.solver?
      @state.solver.suggest(playerId, cardIds, showedIds, progress)
      @setState({ progress: @state.progress+1 })

  render: ->
    <React.Fragment>
      <CssBaseline />
      <div className="App">
        <TopBar
          addPlayer={@addPlayer}
          clearPlayers={@clearPlayers}
          setVersion={@setVersion}
          newGame={@newGame}
          cancelGame={@cancelGame}
          hand={@hand}
          show={@show}
          suggest={@suggest}
          players={@state.players}
          configuration={@state.configuration}
          solver={@state.solver}
          configurations={@configurations}
        />
      </div>
    </React.Fragment>

export default App
