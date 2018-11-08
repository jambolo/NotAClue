`
import React, { Component } from 'react';
import PropTypes from 'prop-types'

import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import FormControl from '@material-ui/core/FormControl';
import FormLabel from '@material-ui/core/FormLabel';
import MenuItem from '@material-ui/core/MenuItem'
import Radio from '@material-ui/core/Radio';
import RadioGroup from '@material-ui/core/RadioGroup';
import TextField from '@material-ui/core/TextField';
`
ConfigurationChoices = (props) ->
  <RadioGroup row aria-label="Versions" name="versions" value={props.configuration} onChange={props.onChange}>
    {(<FormControlLabel key={key} value={key} control={<Radio /> } label={value.name} /> for key, value of props.configurations)}
  </RadioGroup>

ConfigurationChooser = (props) ->
    <FormControl component="fieldset">
      <FormLabel component="legend">Select a version:</FormLabel>
      <ConfigurationChoices
        configuration={props.configuration}
        configurations={props.configurations}
        onChange={(event) -> props.onChange(event.target.value)}
      />
    </FormControl>

class AddPlayerInput extends Component
  constructor: (props) ->
    super(props)
    @state = 
      player: ''

  handleChange: (event) =>
#    console.log("AddPlayerInput::handleChange")
    @setState({ player: event.target.value })

  handleAddPlayer: =>
#    console.log("AddPlayerInput::handleAddPlayer")
    @props.onAddPlayer(@state.player)
    @setState({ player: '' })

  render: ->
    <div>
      <TextField autoFocus margin="dense" fullWidth value={@state.player} onChange={@handleChange} />
      <Button variant="contained" color="primary" onClick={@handleAddPlayer}>Add Player</Button>
    </div>

AddPlayerInput.propTypes =
  onAddPlayer: PropTypes.func.isRequired

PlayerList = (props) ->
    <div>
      <ul>
        {props.names.map( (player) =>
          <li key={player}>{player}</li>
        )}
      </ul>
    </div>

PlayerList.defaultProps =
  names: []

Players = (props) ->
    <div>
      <AddPlayerInput onAddPlayer={props.onAddPlayer} />
      <PlayerList names={props.players} />
      <Button variant="contained" color="primary" onClick={props.onClearPlayers}>Clear Players</Button>
    </div>

class SetupDialog extends Component
  constructor: (props) ->
    super(props)
    @state =
      open: false
      players: @props.players
      configuration: @props.configuration

  handleAddPlayer: (player) =>
#    console.log("SetupDialog::handleAddPlayer(#{player})")
    @setState({ players: @state.players.concat([player]) })

  handleClearPlayers: =>
#    console.log("SetupDialog::handleClearPlayers")
    @setState({ players: [] })

  handleChangeConfiguration: (configuration) =>
#    console.log("SetupDialog::handleChangeConfiguration(#{configuration})")
    @setState({ configuration })

  handleOpen: =>
#    console.log("SetupDialog::handleOpen")
    @setState({ open: true })

  handleDone: =>
#    console.log("SetupDialog::handleDone")
    @setState({ open: false })
    @props.onNewGame(@state.configuration, @state.players)

  handleCancel: =>
#    console.log("SetupDialog::handleCancel")
    @setState({ open: false })
    @props.onClose()

  render: ->
   <div>
      <MenuItem onClick={@handleOpen}>New Game</MenuItem>

      <Dialog open={@state.open} aria-labelledby="form-dialog-title" onClose={@handleCancel}>
        <DialogTitle id="form-dialog-title">New Game</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Select the version of the game and enter the names of the players.
          </DialogContentText>
          <hr />
          <ConfigurationChooser
            configuration={@state.configuration}
            configurations={@props.configurations}
            onChange={@handleChangeConfiguration}
          />
          <hr />
          <Players
            players={@state.players}
            onAddPlayer={@handleAddPlayer}
            onClearPlayers={@handleClearPlayers}
          />
        </DialogContent>
        <DialogActions>
          <Button variant="contained" color="secondary" onClick={@handleCancel}>Cancel</Button>
          <Button disabled={@state.players.length < 2} variant="contained" color="primary" onClick={@handleDone}>Done</Button>
        </DialogActions>
      </Dialog>
    </div>

export default SetupDialog
