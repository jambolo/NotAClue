`
import AppBar from '@material-ui/core/AppBar';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import Radio from '@material-ui/core/Radio';
import RadioGroup from '@material-ui/core/RadioGroup';
import React, { Component } from 'react';
import Tab from '@material-ui/core/Tab';
import Tabs from '@material-ui/core/Tabs';
`

CardList = (props) ->
  { selected, cards, types } = props
  <ul>
    {
      for typeId, value of types
        <li key={typeId}>
          <b>{value.title}</b>: {cards[selected[typeId]].name if selected[typeId]?}
        </li>
    }
  </ul> 

CardChoices = (props) ->
  { value, type, cards, onChange } = props
  <RadioGroup row name="cards" value={value} onChange={onChange}>
    {
      for id, info of cards when info.type is type
        <FormControlLabel 
          key={id} 
          value={id} 
          control={<Radio />} 
          label={info.name} 
        /> 
    }
  </RadioGroup>

class PerCategoryCardChooser extends Component
  constructor: (props) ->
    super props
    @state =
      currentTab: 0
    return

  handleChangeTab: (event, currentTab) =>
    @setState { currentTab }
    return

  makeChangeEventHandler: (typeId) =>
    (event) =>
      @props.onChange typeId, event.target.value

  render: ->
    { value, cards, types } = @props
    tabIds = Object.keys(types)
    tabIndex = if @state.currentTab >= 0 and @state.currentTab < tabIds.length then @state.currentTab else 0
    tabId = tabIds[tabIndex]
    
    <div>
      <AppBar position="static">
        <Tabs value={tabIndex} onChange={@handleChangeTab}>
          {<Tab key={id} label={types[id].title} /> for id in tabIds}
        </Tabs>
      </AppBar>
      <CardChoices 
        value={value[tabId]} 
        cards={cards} 
        type={tabId} 
        onChange={@makeChangeEventHandler(tabId)} 
      />
      <b>Selected Cards:</b>
      <CardList selected={value} cards={cards} types={types} />
    </div>

export default PerCategoryCardChooser
