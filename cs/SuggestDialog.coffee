`
import PerCategoryCardChooser from './PerCategoryCardChooser'
import MultiplePlayerChooser from './MultiplePlayerChooser'
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

class SuggestDialog extends Component
  constructor: (props) ->
    super(props)
    @state =
      suggesterId: null
      cardIds: {}
      showedIds: []

  handleChangeSuggesterId: (playerId) =>
    console.log("HandDialog::handleChangeSuggesterId: (#{playerId})")
    @setState({ suggesterId: playerId })

  handleChangeCards: (typeId, cardId) =>
    @setState((state, props) ->
      newCardIds = Object.assign({}, state.cardIds)
      newCardIds[typeId] = cardId
      { cardIds: newCardIds }
    )

  handleChangeShowedIds: (playerId, selected) =>
    console.log("HandDialog::handleChangeCards: (#{playerId}, #{selected})")
    if selected
      @setState((state, props) ->
        if playerId not in state.showedIds then { showedIds : state.showedIds.concat([playerId]) } else null
      ) 
    else
      @setState((state, props) ->
        if playerId in state.showedIds then { showedIds : (id for id in state.showedIds when id isnt playerId) } else null
      )

  handleDone: =>
    console.log("SuggestDialog::handleDone")
    @props.onClose()
    cardIds = (cardId for typeId, cardId of @state.cardIds)
    if @state.suggesterId? and cardIds.length == 3 and @state.showedIds.length <= 3
      @props.app.recordSuggestion(@state.suggesterId, cardIds, @state.showedIds)
    else
      @props.app.showConfirmDialog("You must select a suggester, 3 cards, and up to 3 players who showed cards.")
    @setState({ suggesterId: null, cardIds: {}, showedIds: [] })

  handleCancel: =>
    console.log("SuggestDialog::handleCancel")
    @props.onClose()
    @setState({ suggesterId: null, cardIds: {}, showedIds: [] })

  render: ->
    <Dialog open={@props.open} onClose={@props.onClose}>
      <DialogTitle id="form-dialog-title">Record A Suggestion</DialogTitle>
      <DialogContent>
        <DialogContentText>
          <h4>Who made the suggestion?</h4>
        </DialogContentText>
        <PlayerChooser value={@state.suggesterId} playerIds={@props.playerIds} onChange={@handleChangeSuggesterId} />
        <Divider />
        <DialogContentText>
          <h4>What cards were suggested?</h4>
        </DialogContentText>
        <PerCategoryCardChooser 
          value={@state.cardIds} 
          cards={@props.configuration.cards} 
          types={@props.configuration.types} 
          onChange={@handleChangeCards} 
        />
        <Divider />
        <DialogContentText>
          <h4>Who showed cards?</h4>
        </DialogContentText>
        <MultiplePlayerChooser 
          value={@state.showedIds} 
          playerIds={@props.playerIds} 
          excluded={if @state.suggesterId isnt null then [@state.suggesterId] else []} 
          onChange={@handleChangeShowedIds} 
        />
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}>Cancel</Button>
        <Button variant="contained" color="primary" onClick={@handleDone}>Done</Button>
      </DialogActions>
    </Dialog>

export default SuggestDialog
