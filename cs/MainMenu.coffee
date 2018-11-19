`
import React, { Component } from 'react';

import Menu from '@material-ui/core/Menu'
import MenuItem from '@material-ui/core/MenuItem'
`

class MainMenu extends Component
  handleStart: =>
    @props.onClose()
    @props.app.showNewGameDialog()

  handleClear: =>
    @props.onClose()
    @props.app.showConfirmDialog("Are you sure you want to clear the current game?", @props.app.clearGame, () -> {})

  render: ->
    <Menu id="main-menu" anchorEl={@props.anchor} open={Boolean(@props.anchor)} onClose={@props.onClose}>
      <MenuItem onClick={@handleStart}>Start New Game</MenuItem>
      <MenuItem onClick={@handleClear}>Clear Current Game</MenuItem>
    </Menu>

export default MainMenu
