`
import MultipleCardChooser from './MultipleCardChooser'
import PlayerChooser from './PlayerChooser'

import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import Divider from '@material-ui/core/Divider';
import React, { Component } from 'react';
`

class HandDialog extends Component
  constructor: (props) ->
    super(props)
    @state =
      playerId: null
      cardIds: []

  handleChangePlayer: (playerId) =>
    @setState({ playerId })

  handleChangeCards: (cardId, selected) =>
    if selected
      @setState((state, props) -> 
        if cardId not in state.cardIds then { cardIds : state.cardIds.concat([cardId]) } else null
      ) 
    else
      @setState((state, props) -> 
        if cardId in state.cardIds then { cardIds : (id for id in state.cardIds when id isnt cardId) } else null
      )

  handleDone: =>
    if @state.playerId? and @state.cardIds.length > 0
      @props.app.recordHand(@state.playerId, @state.cardIds)
      @setState({ playerId: null, cardIds:[] })
      @props.onClose()
    else
      @props.app.showConfirmDialog("Error", "You must select a player and at least one card")

  handleCancel: =>
    @setState({ playerId: null, cardIds:[] })
    @props.onClose()

  render: ->
    <Dialog open={@props.open} fullscreen="true" onClose={@handleCancel}>
      <DialogTitle id="form-dialog-title">Record Hand</DialogTitle>
      <DialogContent>
        <DialogContentText><h4>Which player?</h4></DialogContentText>
        <PlayerChooser value={@state.playerId} playerIds={@props.playerIds} onChange={@handleChangePlayer} />
        <Divider />
        <DialogContentText><h4>Select the cards in the player's hand:</h4></DialogContentText>
        <MultipleCardChooser 
          value={@state.cardIds} 
          cards={@props.configuration.cards} 
          types={@props.configuration.types} 
          excluded={[]} 
          onChange={@handleChangeCards} 
        />
     </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}>Cancel</Button>
        <Button variant="contained" color="primary" onClick={@handleDone}>Done</Button>
      </DialogActions>
    </Dialog>

export default HandDialog
