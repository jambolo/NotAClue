`
import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import Divider from '@material-ui/core/Divider';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import FormControl from '@material-ui/core/FormControl';
import FormLabel from '@material-ui/core/FormLabel';
import PropTypes from 'prop-types'
import Radio from '@material-ui/core/Radio';
import RadioGroup from '@material-ui/core/RadioGroup';
import React, { Component } from 'react';
import TextField from '@material-ui/core/TextField';
`
ConfigurationChoices = (props) ->
  <RadioGroup row name="variations" value={props.configurationId} onChange={props.onChange}>
    {(
      for key, value of props.configurations
        <FormControlLabel 
          key={key} 
          value={key} 
          control={<Radio /> } 
          label={value.name} 
        /> 
    )}
  </RadioGroup>

ConfigurationChooser = (props) ->
    <FormControl component="fieldset">
      <FormLabel component="legend"><h4>Select a variation:</h4></FormLabel>
      <ConfigurationChoices
        configurationId={props.configurationId}
        configurations={props.configurations}
        onChange={(event) -> props.onChange(event.target.value)}
      />
    </FormControl>

class AddPlayerInput extends Component
  constructor: (props) ->
    super(props)
    @state = 
      playerId: ''

  handleChange: (event) =>
    @setState({ playerId: event.target.value })

  handleKeyDown: (event) =>
    if event.keyCode == 13
      @handleAddPlayer()
    return

  handleAddPlayer: =>
    if @state.playerId != ""
      if @state.playerId != "ANSWER" and @state.playerId not in @props.playerIds
        @props.onAddPlayer(@state.playerId)
      else
        @props.app.showConfirmDialog("Error", "A player's name must be unique and it cannot be ANSWER.")
      @setState({ playerId: '' })

  render: ->
    <div>
      <TextField 
        autoFocus 
        margin="normal" 
        value={@state.playerId} 
        onChange={@handleChange}
        onKeyDown={@handleKeyDown} 
      />
      <Button 
        disabled={@props.count >= @props.max} 
        variant="contained" 
        color="primary" 
        onClick={@handleAddPlayer}
      >
        Add
      </Button>
    </div>

AddPlayerInput.propTypes =
  playerIds:    PropTypes.arrayOf(PropTypes.string).isRequired
  count:        PropTypes.number.isRequired
  max:          PropTypes.number.isRequired
  onAddPlayer:  PropTypes.func.isRequired

PlayerList = (props) ->
    <ul>
      {props.names.map((playerId) => <li key={playerId}>{playerId}</li>)}
    </ul>

PlayerList.defaultProps =
  names: []

Players = (props) ->
    <div>
      <AddPlayerInput 
        playerIds={props.playerIds} 
        count={props.playerIds.length} 
        max={props.max} 
        app={props.app}
        onAddPlayer={props.onAddPlayer} 
      />
      <PlayerList names={props.playerIds} />
      <Button variant="contained" color="primary" onClick={props.onClearPlayers}>Clear Players</Button>
    </div>

class SetupDialog extends Component
  constructor: (props) ->
    super(props)
    @state =
      playerIds: []
      configurationId: @props.configurationId

  handleAddPlayer: (playerId) =>
    @setState( (state, props) -> { playerIds: state.playerIds.concat([playerId]) } )

  handleClearPlayers: =>
    @setState({ playerIds: [] })

  handleChangeConfiguration: (configurationId) =>
    @setState({ configurationId })

  handleDone: =>
    @props.onClose()
    @props.app.newGame(@state.configurationId, @state.playerIds)

  handleCancel: =>
    @props.onClose()

  render: ->
    numPlayers = @state.playerIds.length
    minPlayers = @props.configurations[@state.configurationId].minPlayers
    maxPlayers = @props.configurations[@state.configurationId].maxPlayers

    <Dialog open={@props.open} onClose={@handleCancel}>
      <DialogTitle id="form-dialog-title">New Game</DialogTitle>
      <DialogContent>
        <ConfigurationChooser
          configurationId={@state.configurationId}
          configurations={@props.configurations}
          onChange={@handleChangeConfiguration}
        />
        <Divider />
        <DialogContentText><h4>Add players:</h4></DialogContentText>
        <Players
          playerIds={@state.playerIds}
          max={maxPlayers}
          app={@props.app}
          onAddPlayer={@handleAddPlayer}
          onClearPlayers={@handleClearPlayers}
        />
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}>Cancel</Button>
        <Button 
          disabled={numPlayers < minPlayers} 
          variant="contained" 
          color="primary" 
          onClick={@handleDone}
        >
          Done
        </Button>
      </DialogActions>
    </Dialog>

export default SetupDialog
