`
import CardChooser from './CardChooser'
import PlayerChooser from './PlayerChooser'


import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import React, { Component } from 'react';
`

class HandDialog extends Component
  constructor: (props) ->
    super(props)
    @state =
      playerId: @props.playerIds[0]
      cardIds: []

  handleChangePlayer: (playerId) =>
    @setState({ playerId })

  handleChangeCards: (cardIds) ->
    @setState({ cardIds })

  handleDone: =>
#    console.log("HandDialog::handleDone")
    @props.onClose()
    @props.app.recordHand(@state.playerId, @state.cardIds)

  handleCancel: =>
#    console.log("HandDialog::handleCancel")
    @props.onClose()

  render: ->
    <Dialog open={@props.open} onClose={@props.onClose}>
      <DialogTitle id="form-dialog-title">Record Hand</DialogTitle>
      <DialogContent>
        <PlayerChooser playerId={@state.playerId} playerIds={@props.playerIds} onChange={@handleChangePlayer} />
        <DialogContentText>
          Select the cards in the player's hand:
        </DialogContentText>
        <CardChooser cards={@props.configuration.cards} types={@props.configuration.types} onChange={@handleChangeCards} />
     </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}>Cancel</Button>
        <Button variant="contained" color="primary" onClick={@handleDone}>Done</Button>
      </DialogActions>
    </Dialog>

export default HandDialog
