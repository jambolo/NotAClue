`
import React, { Component } from 'react';

import Menu from '@material-ui/core/Menu'
import MenuItem from '@material-ui/core/MenuItem'
`

class MainMenu extends Component
  handleStart: =>
    @props.app.showNewGameDialog()
    @props.onClose()

  handleClear: =>
    @props.app.showConfirmDialog("Please confirm", "Are you sure you want to clear the current game?", @props.app.clearGame, () -> {})
    @props.onClose()

  handleLog: =>
    @props.app.showLog()
    @props.onClose()

  render: ->
    <Menu id="main-menu" anchorEl={@props.anchor} open={Boolean(@props.anchor)} onClose={@props.onClose}>
      <MenuItem onClick={@handleStart}>Start New Game</MenuItem>
      <MenuItem onClick={@handleClear}>Clear Current Game</MenuItem>
      <MenuItem disabled={not @props.enableShowLog} onClick={@handleLog}>Show Log</MenuItem>
    </Menu>

export default MainMenu
