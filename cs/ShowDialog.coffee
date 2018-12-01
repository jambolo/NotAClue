`
import PlayerChooser from './PlayerChooser'
import CardChooser from './CardChooser'

import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import Divider from '@material-ui/core/Divider';
import React, { Component } from 'react';
import Typography from '@material-ui/core/Typography'
`

class ShowDialog extends Component
  constructor: (props) ->
    super(props)
    @state =
      playerId: null
      cardId: null
    return

  stateIsOk: ->
    @state.playerId? and @state.cardId?

  handleChangePlayer: (playerId) =>
    @setState({ playerId })
    return

  handleChangeCard: (cardId) =>
    @setState({ cardId })
    return

  handleDone: =>
    if @stateIsOk()
      @props.app.recordShown(@state.playerId, @state.cardId)
      @setState({ playerId: null, cardId: null })
      @props.onClose()
    else
      @props.app.showConfirmDialog("Error", "You must select a player and a card")
    return

  handleCancel: =>
    @setState({ playerId: null, cardId: null })
    @props.onClose()
    return

  render: ->
    { open, players, configuration } = @props
    <Dialog open={open} fullscreen="true" disableBackdropClick={true} onClose={@handleCancel}>
      <DialogTitle id="form-dialog-title">Record A Shown Card</DialogTitle>
      <DialogContent>
        <Typography variant="h4">Who showed the card?</Typography>
        <PlayerChooser 
          value={@state.playerId} 
          players={players} 
          onChange={@handleChangePlayer} />
        <Divider />
        <Typography variant="h4">What card did they show?</Typography>
        <CardChooser
          value={@state.cardId} 
          cards={configuration.cards} 
          types={configuration.types} 
          onChange={@handleChangeCard} 
        />
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}>Cancel</Button>
        <Button disabled={not @stateIsOk()} variant="contained" color="primary" onClick={@handleDone}>Done</Button>
      </DialogActions>
    </Dialog>

export default ShowDialog
