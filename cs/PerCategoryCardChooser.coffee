`
import AppBar from '@material-ui/core/AppBar';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import Radio from '@material-ui/core/Radio';
import RadioGroup from '@material-ui/core/RadioGroup';
import Tab from '@material-ui/core/Tab';
import Tabs from '@material-ui/core/Tabs';

import React, { Component } from 'react';
`

CardList = (props) ->
  { selectedIds, cards, types } = props
  <ul>
    {(
      for typeId, value of types
        <li key={typeId}>
          <b> {value.title}: </b> {cards[selectedIds[typeId]].name if selectedIds[typeId]?}
        </li>
    )}
  </ul> 

CardChoices = (props) ->
  <RadioGroup row name="cards" value={props.value} onChange={props.onChange}>
    {(
      for id, info of props.cards when info.type is props.typeId
        <FormControlLabel 
          key={id} 
          value={id} 
          control={<Radio />} 
          label={info.name} 
        /> 
    )}
  </RadioGroup>

class PerCategoryCardChooser extends Component
  constructor: (props) ->
    super(props)
    @state =
      currentTab: 0

  handleChangeTab: (event, currentTab) =>
    @setState({ currentTab });

  changeEventHandler: (typeId) =>
    (event) =>
      @props.onChange(typeId, event.target.value)

  render: ->
    { value, cards, types } = @props
    tabIds = (id for id of types)
    tabIndex = if @state.currentTab >= 0 and @state.currentTab < tabIds.length then @state.currentTab else 0
    tabId = tabIds[tabIndex]
    <div>
      <AppBar position="static">
        <Tabs value={tabIndex} onChange={@handleChangeTab}>
          {(<Tab key={id} label={types[id].title} /> for id in tabIds)}
        </Tabs>
      </AppBar>
      <CardChoices 
        value={value[tabId]} 
        cards={cards} 
        typeId={tabId} 
        onChange={@changeEventHandler(tabId)} 
      />
      <h4>Selected Cards:</h4>
      <CardList selectedIds={value} cards={cards} types={types} />
    </div>

export default PerCategoryCardChooser
