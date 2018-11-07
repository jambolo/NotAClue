`
import React, { Component } from 'react';
import PropTypes from 'prop-types'

import Button from '@material-ui/core/Button';
import TextField from '@material-ui/core/TextField';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
`

class AddPlayer extends Component
  constructor: (props) ->
    super(props)
    @state = 
      newPlayer: ''

  updateNewPlayer: (event) =>
    console.log("AddPlayer::updateNewPlayer")
    @setState({ newPlayer: event.target.value })

  handleAddPlayer: =>
    console.log("AddPlayer::handleAddPlayer")
    @props.addPlayer(@state.newPlayer)
    @setState({ newPlayer: '' })

  render: ->
    <div>
      <TextField autoFocus margin="dense" fullWidth  value={@state.newPlayer} onChange={@updateNewPlayer} />
      <Button onClick={@handleAddPlayer}> Add Player </Button>
    </div>

AddPlayer.propTypes =
  addPlayer: PropTypes.func.isRequired

class PlayerList extends Component
  render: ->
    <div>
      <h4>Players</h4>
      <ul>
        {@props.names.map( (player) =>
          <li> {player} </li>
        )}
      </ul>
    </div>

PlayerList.defaultProps =
  names: []

class Players extends Component
  constructor: (props) ->
    super(props)
    @state =
      players: []

  addPlayer: (player) ->
    console.log("Players::addPlayer")
    @setState( (state) => ({ players: state.friends.concat([player]) }) )

  handleClear: ->
    console.log("Players::handleClear")
    @setState( () => ({ players: [] }) )

  render: ->
    <div>
      <AddPlayer addPlayer={@addPlayer} />
      <PlayerList names={@state.players} />
      <Button onClick={@handleClear}> Clear Players </Button>
    </div>

class SetupDialog extends Component
  constructor: (props) ->
    super(props)
    @state =
      open: false
      canceled: false

  handleDone: () =>
    console.log("SetupDialog::handleDone")
    @setState({ open: false, canceled: false })

  handleCancel: () =>
    console.log("SetupDialog::handleCancel")
    @setState({ open: false, canceled: true})

  render: ->
   <div>
      <Dialog open={@state.open} onClose={@handleCancel} aria-labelledby="form-dialog-title" >
        <DialogTitle id="form-dialog-title">Subscribe</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Select the version of the game and enter the names of the players.
          </DialogContentText>
          <Players />
        </DialogContent>
        <DialogActions>
          <Button onClick={@handleCancel} color="danger"> Cancel </Button>
          <Button onClick={@handleDone} color="primary"> Done </Button>
        </DialogActions>
      </Dialog>
    </div>

export default SetupDialog
