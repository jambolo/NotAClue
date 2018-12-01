`
import Menu from '@material-ui/core/Menu'
import MenuItem from '@material-ui/core/MenuItem'
import React, { Component } from 'react';
`

version = require './version'

class MainMenu extends Component
  handleStart: =>
    @props.app.showNewGameDialog()
    @props.onClose()
    return

  handleClear: =>
    @props.app.showConfirmDialog("Please confirm", "Are you sure you want to clear the current game?", @props.app.clearGame, () -> {})
    @props.onClose()
    return

  handleLog: =>
    @props.app.showLog()
    @props.onClose()
    return

  render: ->
    { anchor, started, onClose} = @props
    <Menu id="main-menu" anchorEl={anchor} open={Boolean(anchor)} onClose={onClose}>
      <MenuItem onClick={@handleStart}> Start New Game </MenuItem>
      <MenuItem onClick={@handleClear}> Clear Current Game </MenuItem>
      <MenuItem disabled={not started} onClick={@handleLog}> Show Log </MenuItem>
      <MenuItem disabled={true}> {version} </MenuItem>
    </Menu>

export default MainMenu
