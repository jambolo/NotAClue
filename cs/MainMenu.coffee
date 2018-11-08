`
import React, { Component } from 'react';

import IconButton from '@material-ui/core/IconButton';
import Menu from '@material-ui/core/Menu'
import MenuIcon from '@material-ui/icons/Menu';
import MenuItem from '@material-ui/core/MenuItem'
import SetupDialog from "./SetupDialog"
`

class MainMenu extends Component
  constructor: (props) ->
    super(props)
    @state =
      anchorEl: null

  handleClickMainMenu: (event) =>
#    console.log("MainMenu::handleClickMainMenu")
    @setState({ anchorEl: event.currentTarget })

  handleNewGame: (configuration, players) =>
#    console.log("MainMenu::handleNewGame(#{configuration}, #{players})")
    @setState({ anchorEl: null })
    @props.onNewGame(configuration, players)

  handleClearGame: =>
#    console.log("MainMenu::handleClearGame")
    @setState({ anchorEl: null })
    @props.onClearGame()

  handleClose: =>
#    console.log("MainMenu::handleClose")
    @setState({ anchorEl: null })

  render: ->
    { anchorEl } = @state

    <div>
      <IconButton color="inherit" onClick={@handleClickMainMenu}>
        <MenuIcon />
      </IconButton>

      <Menu id="main-menu" anchorEl={anchorEl} open={Boolean(anchorEl)} onClose={@handleClose}>
        <SetupDialog
          configurations={@props.configurations}
          players={@props.players}
          configuration={@props.configuration}
          onNewGame={@handleNewGame}
          onClose={@handleClose}
        />
        <MenuItem onClick={@handleClearGame}>Clear Game</MenuItem>
      </Menu>
    </div>

export default MainMenu
