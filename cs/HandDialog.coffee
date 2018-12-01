`
import MultipleCardChooser from './MultipleCardChooser'
import PlayerChooser from './PlayerChooser'

import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import Divider from '@material-ui/core/Divider';
import React, { Component } from 'react';
import Typography from '@material-ui/core/Typography'
`

class HandDialog extends Component
  constructor: (props) ->
    super(props)
    @state =
      playerId: null
      cardIds: []

  stateIsOk: ->
    @state.playerId? and @state.cardIds.length > 0

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
    if @stateIsOk()
      @props.app.recordHand(@state.playerId, @state.cardIds)
      @setState({ playerId: null, cardIds:[] })
      @props.onClose()
    else
      @props.app.showConfirmDialog("Error", "You must select a player and at least one card")

  handleCancel: =>
    @setState({ playerId: null, cardIds:[] })
    @props.onClose()

  render: ->
    { open, players, configuration } = @props
    <Dialog open={open} fullscreen="true" disableBackdropClick={true} onClose={@handleCancel}>
      <DialogTitle id="form-dialog-title">Record Your Hand</DialogTitle>
      <DialogContent>
        <Typography variant="h6">Which player are you?</Typography>
        <PlayerChooser value={@state.playerId} players={players} onChange={@handleChangePlayer} />
        <Divider />
        <Typography variant="h6">Select the cards in your hand:</Typography>
        <MultipleCardChooser 
          value={@state.cardIds} 
          cards={configuration.cards} 
          types={configuration.types} 
          onChange={@handleChangeCards} 
        />
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}>Cancel</Button>
        <Button disabled={not @stateIsOk()} variant="contained" color="primary" onClick={@handleDone}>Done</Button>
      </DialogActions>
    </Dialog>

export default HandDialog
