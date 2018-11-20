`
import PerCategoryCardChooser from './PerCategoryCardChooser'
import PlayerChooser from './PlayerChooser'

import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import Divider from '@material-ui/core/Divider';
import FormControl from '@material-ui/core/FormControl';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import Radio from '@material-ui/core/Radio';
import RadioGroup from '@material-ui/core/RadioGroup';
import React, { Component } from 'react';
`

class AccuseDialog extends Component
  constructor: (props) ->
    super(props)
    @state =
      accuserId: null
      cardIds:   {}
      outcome:   null

  handleChangeAccuserId: (playerId) =>
    @setState({ accuserId: playerId })

  handleChangeCards: (typeId, cardId) =>
    @setState((state, props) ->
      newCardIds = Object.assign({}, state.cardIds)
      newCardIds[typeId] = cardId
      { cardIds: newCardIds }
    )

  handleChangeOutcome: (event) =>
    @setState({ outcome: event.target.value })

  handleDone: =>
    cardIds = (cardId for typeId, cardId of @state.cardIds)
    if @state.accuserId? and cardIds.length == 3 and @state.outcome?
      @props.app.recordAccusation(@state.accuserId, cardIds, @state.outcome == "yes")
      @setState({ accuserId: null, cardIds: {}, outcome: null })
      @props.onClose()
    else
      @props.app.showConfirmDialog("Error", "You must select an accuser, 3 cards, and the outcome.")

  handleCancel: =>
    @setState({ accuserId: null, cardIds: {}, outcome: null })
    @props.onClose()

  render: ->
    <Dialog open={@props.open} onClose={@handleCancel}>
      <DialogTitle id="form-dialog-title">Record An Accusation</DialogTitle>
      <DialogContent>
        <DialogContentText>
          <h4>Who made the accusation?</h4>
        </DialogContentText>
        <PlayerChooser value={@state.accuserId} playerIds={@props.playerIds} onChange={@handleChangeAccuserId} />
        <Divider />
        <DialogContentText>
          <h4>What was the accusation?</h4>
        </DialogContentText>
        <PerCategoryCardChooser 
          value={@state.cardIds} 
          cards={@props.configuration.cards} 
          types={@props.configuration.types} 
          onChange={@handleChangeCards} 
        />
        <Divider />
        <DialogContentText>
          <h4>Was the accusation correct?</h4>
        </DialogContentText>
        <FormControl component="fieldset">
          <RadioGroup row name="outcome" value={@state.outcome} onChange={@handleChangeOutcome}>
            <FormControlLabel value={"yes"} control={<Radio />}  label="Yes" /> 
            <FormControlLabel value={"no"} control={<Radio />}  label="No" /> 
          </RadioGroup>
        </FormControl>
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}>Cancel</Button>
        <Button variant="contained" color="primary" onClick={@handleDone}>Done</Button>
      </DialogActions>
    </Dialog>

export default AccuseDialog
