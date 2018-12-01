`
import PerCategoryCardChooser from './PerCategoryCardChooser'
import PlayerChooser from './PlayerChooser'

import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import Divider from '@material-ui/core/Divider';
import FormControl from '@material-ui/core/FormControl';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import Radio from '@material-ui/core/Radio';
import RadioGroup from '@material-ui/core/RadioGroup';
import React, { Component } from 'react';
import Typography from '@material-ui/core/Typography'
`


ShowedChooser = (props) ->
  value = if props.value then "yes" else "no"
  <FormControl component="fieldset">
    <RadioGroup row name="showed" value={value} onChange={props.onChange}>
      <FormControlLabel value="yes" control={<Radio />} label="Yes" /> 
      <FormControlLabel value="no" control={<Radio />} label="No" /> 
    </RadioGroup>
  </FormControl>

class CommlinkDialog extends Component
  constructor: (props) ->
    super(props)
    @state =
      callerId:   null
      receiverId: null
      cardIds:    {}
      showed:     false
    return

  close: ->
    @setState({ callerId: null, receiverId: null, cardIds: {}, showed: false })
    @props.onClose()
    return

  stateIsOk: ->
    cardCount = (key for key of @state.cardIds).length
    @state.callerId? and @state.receiverId? and cardCount == 3

  handleChangeCallerId: (playerId) =>
    @setState({ callerId: playerId })
    return

  handleChangeSubjectId: (playerId) =>
    @setState({ receiverId: playerId })
    return

  handleChangeCards: (typeId, cardId) =>
    @setState((state, props) ->
      newCardIds = Object.assign({}, state.cardIds)
      newCardIds[typeId] = cardId
      { cardIds: newCardIds }
    )
    return

  handleChangeShowed: (event) =>
    @setState({ showed: event.target.value is "yes" })
    return

  handleDone: =>
    if @stateIsOk()
      cardIds = (cardId for typeId, cardId of @state.cardIds)
      @props.app.recordCommlink(@state.callerId, @state.receiverId, cardIds, @state.showed)
      @close()
    else
      @props.app.showConfirmDialog("Error", "You must select an caller, a receiver, and one card of each type.")
    return

  handleCancel: =>
    @close()
    return

  render: ->
    { open, players, configuration } = @props
    <Dialog open={open} fullscreen="true" disableBackdropClick={true} onClose={@handleClose}>
      <DialogTitle id="form-dialog-title"> Record A Commlink </DialogTitle>
      <DialogContent>
        <Typography variant="h4"> Who is the caller? </Typography>
        <PlayerChooser 
          value={@state.callerId} 
          players={players} 
            excluded={if @state.receiverId? then [@state.receiverId] else []} 
          onChange={@handleChangeCallerId} 
        />
        <Divider />
        <Typography variant="h4"> Who is the receiver? </Typography>
        <PlayerChooser 
          value={@state.receiverId} 
          players={players} 
            excluded={if @state.callerId? then [@state.callerId] else []} 
          onChange={@handleChangeSubjectId} 
          />
        <Divider />
        <Typography variant="h4"> Which cards? </Typography>
        <PerCategoryCardChooser 
          value={@state.cardIds} 
          cards={configuration.cards} 
          types={configuration.types} 
          onChange={@handleChangeCards} 
        />
        <Divider />
          <Typography variant="h4"> Was a card shown? </Typography>
          <ShowedChooser 
            value={@state.showed} 
            onChange={@handleChangeShowed} 
          />
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}>Cancel</Button>
        <Button disabled={not @stateIsOk()} variant="contained" color="primary" onClick={@handleDone}>Done</Button>
      </DialogActions>
    </Dialog>

export default CommlinkDialog
