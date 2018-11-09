`
import AppBar from '@material-ui/core/AppBar';
import Tab from '@material-ui/core/Tab';
import Tabs from '@material-ui/core/Tabs';

import React, { Component } from 'react';
`

GroupCardList = (props) ->
  { group, cards } = props
  <ul>
    {(<li key={cardId}>{cards[cardId].name}</li> for cardId, checked of group when checked)}
  </ul>

CardList = (props) ->
  {cards, cardIds, types} = props

  <ul>
    {(<li key={typeId}> {types[typeId].title} <GroupCardList group={group} cards={cards} /> </li> for typeId, group of cardIds )}
  </ul> 

class CardChooser extends Component
  constructor: (props) ->
    super(props)
    @state =
      cardIds:    {suspect: {mustard: true}, weapon: {rope: true, wrench: false}, room: {library:true, conservatory: false}}
      currentTab: 0
    @tabIds = (id for id of @props.types)

  handleChangeTab: (event, currentTab) =>
    @setState({ currentTab });

  handleChangeCards: (typeId, cardId) => (event) =>
    @setState({ [typeId]: [cardId]: event.target.checked });

  render: ->
    <div>
      <AppBar position="static">
        <Tabs value={@state.currentTabId} onChange={@handleChangeTab}>
          {(<Tab label={@props.types[id].name} /> for id in @tabIds)}
        </Tabs>
      </AppBar>
      Selected:
      <CardList cards={@props.cards} cardIds={@state.cardIds} types={@props.types} />
    </div>

export default CardChooser
