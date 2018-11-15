`
import PlayerChooser from './PlayerChooser'
import CardChooser from './CardChooser'

import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import Divider from '@material-ui/core/Divider';

import React, { Component } from 'react';
`

class ShowDialog extends Component
  constructor: (props) ->
    super(props)
    @state =
      playerId: null
      cardId: null

  handleChangePlayer: (playerId) =>
    console.log("ShowDialog::handleChangePlayer: (#{playerId})")
    @setState({ playerId })

  handleChangeCard: (cardId) =>
    console.log("ShowDialog::handleChangeCard: (#{cardId})")
    @setState({ cardId })

  handleDone: =>
    console.log("ShowDialog::handleDone")
    @props.onClose()
    if @state.playerId? and @state.cardId?
      @props.app.recordShown(@state.playerId, @state.cardId)
    else
      @props.app.showConfirmDialog("You must select a player and a card")
    @setState({ playerId: null, cardId: null })

  handleCancel: =>
    console.log("ShowDialog::handleCancel")
    @props.onClose()
    @setState({ playerId: null, cardId: null })

  render: ->
    <Dialog open={@props.open} onClose={@props.onClose}>
      <DialogTitle id="form-dialog-title">Record A Shown Card</DialogTitle>
      <DialogContent>
        <DialogContentText><h4>Who showed the card?</h4></DialogContentText>
        <PlayerChooser 
          value={@state.playerId} 
          playerIds={@props.playerIds} 
          onChange={@handleChangePlayer} />
        <Divider />
        <DialogContentText><h4>What card did they show?</h4></DialogContentText>
        <CardChooser
          value={@state.cardId} 
          cards={@props.configuration.cards} 
          types={@props.configuration.types} 
          onChange={@handleChangeCard} 
        />
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}>Cancel</Button>
        <Button variant="contained" color="primary" onClick={@handleDone}>Done</Button>
      </DialogActions>
    </Dialog>

export default ShowDialog
