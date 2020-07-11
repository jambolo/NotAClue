`
import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import Divider from '@material-ui/core/Divider';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import FormControl from '@material-ui/core/FormControl';
import FormLabel from '@material-ui/core/FormLabel';
import Radio from '@material-ui/core/Radio';
import RadioGroup from '@material-ui/core/RadioGroup';
import React, { Component } from 'react';
import TextField from '@material-ui/core/TextField';
import Typography from '@material-ui/core/Typography';
`
ConfigurationChoices = (props) ->
  <RadioGroup row name="variations" value={props.configuration} onChange={props.onChange}>
    {
      for key, value of props.configurations
        <FormControlLabel 
          key={key} 
          value={key} 
          control={<Radio /> } 
          label={value.name} 
        /> 
    }
  </RadioGroup>

ConfigurationChooser = (props) ->
  <FormControl component="fieldset">
    <FormLabel component="legend"><Typography variant="h6">Select a variation:</Typography></FormLabel>
    <ConfigurationChoices
      configuration={props.configuration}
      configurations={props.configurations}
      onChange={(event) -> props.onChange(event.target.value)}
    />
  </FormControl>

class AddPlayerInput extends Component
  constructor: (props) ->
    super props
    @state = 
      playerId: ""
    return

  handleChange: (event) =>
    @setState { playerId: event.target.value }
    return

  handleKeyDown: (event) =>
    if event.keyCode == 13 and @props.count < @props.max
      @handleAddPlayer()
    return

  handleAddPlayer: =>
    if @state.playerId isnt ""
      if @state.playerId isnt "ANSWER" and @state.playerId not in @props.players
        @props.onAddPlayer @state.playerId
      else
        @props.app.showConfirmDialog(
          "Error",
          "A player's name must be unique and it cannot be ANSWER."
        )
      @setState { playerId: "" }
    return

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

PlayerList = (props) ->
  <ol>
    {props.names.map((playerId) => <li key={playerId}> {playerId} </li>)}
  </ol>

AddPlayers = (props) ->
  { players, max, app, onAddPlayer, onClearPlayers } = props
  <div>
    <AddPlayerInput 
      players={players} 
      count={players.length} 
      max={max} 
      app={app}
      onAddPlayer={onAddPlayer} 
    />
    <PlayerList names={players} />
    <Button variant="contained" color="primary" onClick={onClearPlayers}>Clear Players</Button>
  </div>

class SetupDialog extends Component
  constructor: (props) ->
    super props
    @state =
      playerIds:       []
      configurationId: null
    return

  handleClose: =>
    @props.onClose()
    return

  handleAddPlayer: (playerId) =>
    @setState (state, props) -> { playerIds: state.playerIds.concat([playerId]) }
    return

  handleClearPlayers: =>
    @setState { playerIds: [] }
    return

  handleChangeConfiguration: (configurationId) =>
    @setState { configurationId }
    return

  handleDone: =>
    @props.onDone @state.configurationId, @state.playerIds
    @props.onClose()
    return

  handleCancel: =>
    @props.onClose()
    return

  render: ->
    { open, configurations, app } = @props
    numPlayers = @state.playerIds.length
    minPlayers = if @state.configurationId then configurations[@state.configurationId].minPlayers else 0
    maxPlayers = if @state.configurationId then configurations[@state.configurationId].maxPlayers else 0

    <Dialog open={open} fullscreen="true" disableBackdropClick={true} onClose={@handleClose}>
      <DialogTitle id="form-dialog-title">New Game</DialogTitle>
      <DialogContent>
        <ConfigurationChooser
          configuration={@state.configurationId}
          configurations={configurations}
          onChange={@handleChangeConfiguration}
        />
        <Divider />
        <Typography variant="h6">{ if maxPlayers > 0 then "Add up to #{maxPlayers} players:" else "Add players:"}</Typography>
        <AddPlayers
          players={@state.playerIds}
          max={maxPlayers}
          app={app}
          onAddPlayer={@handleAddPlayer}
          onClearPlayers={@handleClearPlayers}
        />
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}>Cancel</Button>
        <Button 
          disabled={not @state.configurationId? or numPlayers < minPlayers} 
          variant="contained" 
          color="primary" 
          onClick={@handleDone}
        >
          Done
        </Button>
      </DialogActions>
    </Dialog>

export default SetupDialog
