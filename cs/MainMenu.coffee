import React from 'react'

import Menu from '@material-ui/core/Menu'
import MenuItem from '@material-ui/core/MenuItem'

class MainMenu extends Component
  state =
    anchorEl: null

  handleNewGame: () =>
    console.log("MainMenu::handleNewGame")
    @setState({ anchorEl: null });

  handleClose: () =>
    console.log("MainMenu::handleClose")
    @setState({ anchorEl: null });

  render: ->
    { anchorEl } = @state

    <div>
      <Menu id="main-menu" anchorEl={anchorEl} open={Boolean(anchorEl)} onClose={@handleClose} >
        <MenuItem onClick={@handleNewGame}>New Game</MenuItem>
        <MenuItem onClick={@handleClose}>My account</MenuItem>
        <MenuItem onClick={@handleClose}>Logout</MenuItem>
      </Menu>
    </div>

export default MainMenu
