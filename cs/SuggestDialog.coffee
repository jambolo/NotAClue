`
import PerCategoryCardChooser from './PerCategoryCardChooser'
import MultiplePlayerChooser from './MultiplePlayerChooser'
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

class SuggestDialog extends Component
  constructor: (props) ->
    super(props)
    @state =
      suggesterId: null
      cardIds: {}
      showedIds: []

  handleChangeSuggesterId: (playerId) =>
    @setState({ suggesterId: playerId })

  handleChangeCards: (typeId, cardId) =>
    @setState((state, props) ->
      newCardIds = Object.assign({}, state.cardIds)
      newCardIds[typeId] = cardId
      { cardIds: newCardIds }
    )

  handleChangeShowedIds: (playerId, selected) =>
    if selected
      @setState((state, props) ->
        if playerId not in state.showedIds then { showedIds : state.showedIds.concat([playerId]) } else null
      ) 
    else
      @setState((state, props) ->
        if playerId in state.showedIds then { showedIds : (id for id in state.showedIds when id isnt playerId) } else null
      )

  handleDone: =>
    cardIds = (cardId for typeId, cardId of @state.cardIds)
    if @state.suggesterId? and cardIds.length == 3 and @state.showedIds.length <= 3
      if @state.showedIds.length > 0
        @props.app.recordSuggestion(@state.suggesterId, cardIds, @state.showedIds)
        @setState({ suggesterId: null, cardIds: {}, showedIds: [] })
        @props.onClose()
      else
        @props.app.showConfirmDialog("Please confirm", "Are you sure that nobody showed any cards?",
          () =>       
            @props.app.recordSuggestion(@state.suggesterId, cardIds, @state.showedIds)
            @setState({ suggesterId: null, cardIds: {}, showedIds: [] })
            @props.onClose()
          ,
          () -> {}
        )
    else
      @props.app.showConfirmDialog("Error", "You must select a suggester, 3 cards, and up to 3 players who showed cards.")

  handleCancel: =>
    @setState({ suggesterId: null, cardIds: {}, showedIds: [] })
    @props.onClose()

  render: ->
    { open, players, configuration } = @props
    <Dialog open={open} onClose={@handleCancel}>
      <DialogTitle id="form-dialog-title">Record A Suggestion</DialogTitle>
      <DialogContent>
        <Typography variant="h4"> Who made the suggestion? </Typography>
        <PlayerChooser value={@state.suggesterId} players={players} onChange={@handleChangeSuggesterId} />
        <Divider />
        <Typography variant="h4"> What cards were suggested? </Typography>
        <PerCategoryCardChooser 
          value={@state.cardIds} 
          cards={configuration.cards} 
          types={configuration.types} 
          onChange={@handleChangeCards} 
        />
        <Divider />
        <Typography variant="h4"> Who showed cards?</Typography>
        <MultiplePlayerChooser 
          value={@state.showedIds} 
          players={players} 
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
