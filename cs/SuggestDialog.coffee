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
      suggesterId:   null
      cardIds:       {}
      showedIds:     []
      didNotShowIds: []
    return

  close: () ->
    @setState({ suggesterId: null, cardIds: {}, showedIds: [], didNotShowIds: [] })
    @props.onClose()
    return

  stateIsOkMaster: ->
    cardCount = (key for key of @state.cardIds).length
    return @state.suggesterId? and cardCount == 3 and @state.showedIds.length <= 3

  stateIsOkClassic: ->
    cardCount = (key for key of @state.cardIds).length
    return @state.suggesterId? and cardCount == 3

  stateIsOk: ->
    if @props.configuration.rulesId is "master"
      @stateIsOkMaster()
    else
      @stateIsOkClassic()

  handleChangeSuggesterId: (playerId) =>
    @setState({ suggesterId: playerId })
    return

  handleChangeCards: (typeId, cardId) =>
    @setState((state, props) ->
      newCardIds = Object.assign({}, state.cardIds)
      newCardIds[typeId] = cardId
      { cardIds: newCardIds }
    )
    return

  handleChangeShowedIdsMaster: (playerId, selected) =>
    if selected
      @setState((state, props) ->
        if playerId not in state.showedIds then { showedIds : state.showedIds.concat([playerId]) } else null
      ) 
    else
      @setState((state, props) ->
        if playerId in state.showedIds then { showedIds : (id for id in state.showedIds when id isnt playerId) } else null
      )
    return

  handleChangeShowedIdsClassic: (playerId) =>
    @setState({ showedIds: [playerId] })
    return

  handleChangeDidNotShowIdsClassic: (playerId, selected) =>
    if selected
      @setState((state, props) ->
        if playerId not in state.didNotShowIds then { didNotShowIds : state.didNotShowIds.concat([playerId]) } else null
      ) 
    else
      @setState((state, props) ->
        if playerId in state.didNotShowIds then { didNotShowIds : (id for id in state.didNotShowIds when id isnt playerId) } else null
      )
    return

  handleDoneMaster: =>
    if @stateIsOkMaster()
      cardIds = (cardId for typeId, cardId of @state.cardIds)
      if @state.showedIds.length > 0
        @props.app.recordSuggestion(@state.suggesterId, cardIds, @state.showedIds)
        @close()
      else
        @props.app.showConfirmDialog("Please confirm", "Are you sure that nobody showed any cards?",
          () =>       
            @props.app.recordSuggestion(@state.suggesterId, cardIds, @state.showedIds)
            @close()
          ,
          () -> {}
        )
    else
      @props.app.showConfirmDialog("Error", "You must select a suggester, 3 cards, and up to 3 players who showed cards.")
    return

  handleDoneClassic: =>
    if @stateIsOkClassic()
      cardIds = (cardId for typeId, cardId of @state.cardIds)
      if @state.showedIds[0]?
        @props.app.recordSuggestion(@state.suggesterId, cardIds, @state.didNotShowIds.concat(@state.showedIds))
        @close()
      else
        @props.app.showConfirmDialog("Please confirm", "Are you sure that nobody showed a card?",
          () =>       
            @props.app.recordSuggestion(@state.suggesterId, cardIds, [])
            @close()
          ,
          () -> {}
        )
    else
      @props.app.showConfirmDialog("Error", "You must select a suggester, 3 cards, and up to 3 players who showed cards.")
    return

  handleDone: =>
    if @props.configuration.rulesId is "master"
      @handleDoneMaster()
    else
      @handleDoneClassic()
    return

  handleCancel: =>
    @close()
    return

  render: ->
    { open, players, configuration } = @props
    <Dialog open={open} fullscreen="true" disableBackdropClick={true} onClose={@handleCancel}>
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
        {
          if configuration.rulesId is "master"
            <div>
              <Typography variant="h4"> Who showed a card? </Typography>
              <MultiplePlayerChooser 
                value={@state.showedIds} 
                players={players} 
                excluded={if @state.suggesterId isnt null then [@state.suggesterId] else []} 
                onChange={@handleChangeShowedIdsMaster} 
              />
            </div>
          else
            <div>
              <Typography variant="h4"> Who did not have a card? </Typography>
              <MultiplePlayerChooser 
                value={@state.didNotShowIds} 
                players={players} 
                excluded={if @state.suggesterId isnt null then @state.showedIds.concat([@state.suggesterId]) else []} 
                onChange={@handleChangeDidNotShowIdsClassic} 
              />
              <Typography variant="h4"> Who showed a card? </Typography>
              <PlayerChooser 
                value={@state.showedIds[0]} 
                players={players} 
                excluded={if @state.suggesterId isnt null then @state.didNotShowIds.concat([@state.suggesterId]) else []} 
                onChange={@handleChangeShowedIdsClassic} 
              />
            </div>
        }
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}> Cancel </Button>
        <Button disabled={not @stateIsOk()} variant="contained" color="primary" onClick={@handleDone}>
          Done
        </Button>
      </DialogActions>
    </Dialog>

export default SuggestDialog
