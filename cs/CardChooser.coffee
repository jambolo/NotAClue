`
import AppBar from '@material-ui/core/AppBar';
import Checkbox from '@material-ui/core/Checkbox';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import FormGroup from '@material-ui/core/FormGroup';
import Tab from '@material-ui/core/Tab';
import Tabs from '@material-ui/core/Tabs';

import React, { Component } from 'react';
`

GroupCardList = (props) ->
  { selectedIds, typeId, cards } = props
  <ul>
    {(<li key={id}> {cards[id].name} </li> for id in selectedIds when cards[id].type is typeId)}
  </ul>

CardList = (props) ->
  { selectedIds, cards, types } = props

  <ul>
    {(<li key={typeId}> <b> {value.title} </b> <GroupCardList selectedIds={selectedIds} typeId={typeId} cards={cards} /> </li> for typeId, value of types )}
  </ul> 

class CardChooser extends Component
  constructor: (props) ->
    super(props)
    @state =
      currentTab: 0

  handleChangeTab: (event, currentTab) =>
    console.log("CardChooser::handleChangeTab: (event, #{currentTab})")
    @setState({ currentTab });

  handleChangeCards: (cardId) =>
    (event) =>
      console.log("CardChooser::handleChangeCards: (#{cardId}, #{event.target.checked})")
      @props.onChange(cardId, event.target.checked);

  render: ->
    { value, cards, types } = @props
    tabIds = (id for id of types)
    tabIndex = if @state.currentTab >= 0 and @state.currentTab < tabIds.length then @state.currentTab else 0
    <div>
      <AppBar position="static">
        <Tabs value={tabIndex} onChange={@handleChangeTab}>
          {(<Tab key={id} label={types[id].title} /> for id in tabIds)}
        </Tabs>
      </AppBar>
      <FormGroup>
        {(<FormControlLabel key={id} control={<Checkbox checked={id in value} onChange={@handleChangeCards(id)} value={id} />} label={info.name}/> for id, info of cards when info.type is tabIds[tabIndex])}
      </FormGroup>
      <h1>Selected Cards:</h1>
      <CardList selectedIds={value} cards={cards} types={types} />
    </div>

export default CardChooser
