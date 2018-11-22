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
    super(props)
    @state = 
      playerId: ''

  handleChange: (event) =>
    @setState({ playerId: event.target.value })

  handleKeyDown: (event) =>
    if event.keyCode == 13 and @props.count < @props.max
      @handleAddPlayer()
    return

  handleAddPlayer: =>
    if @state.playerId != ""
      if @state.playerId != "ANSWER" and @state.playerId not in @props.players
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

PlayerList = (props) ->
  <ul>
    {props.names.map((playerId) => <li key={playerId}> {playerId} </li>)}
  </ul>

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
    @props.app.newGame(@state.configurationId, @state.playerIds)
    @props.onClose()

  handleCancel: =>
    @props.onClose()

  render: ->
    { open, configurations, app } = @props
    numPlayers = @state.playerIds.length
    minPlayers = configurations[@state.configurationId].minPlayers
    maxPlayers = configurations[@state.configurationId].maxPlayers

    <Dialog open={open} onClose={@handleCancel}>
      <DialogTitle id="form-dialog-title">New Game</DialogTitle>
      <DialogContent>
        <ConfigurationChooser
          configuration={@state.configurationId}
          configurations={configurations}
          onChange={@handleChangeConfiguration}
        />
        <Divider />
        <Typography variant="h6">Add players:</Typography>
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
