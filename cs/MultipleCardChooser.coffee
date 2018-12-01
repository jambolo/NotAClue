`
import AppBar from '@material-ui/core/AppBar';
import Checkbox from '@material-ui/core/Checkbox';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import FormGroup from '@material-ui/core/FormGroup';
import React, { Component } from 'react';
import Tab from '@material-ui/core/Tab';
import Tabs from '@material-ui/core/Tabs';
`

GroupedCardList = (props) ->
  { selected, type, cards } = props
  <ul>
    {<li key={id}> {cards[id].name} </li> for id in selected when cards[id].type is type}
  </ul>

CardList = (props) ->
  { selected, cards, types } = props
  <ul>
    {
      for typeId, value of types
        <li key={typeId}>
          <b>{value.title}</b>
          <GroupedCardList selected={selected} type={typeId} cards={cards} />
        </li>
    }
  </ul> 

class CardChoices extends Component
  makeChangeHandler: (id) =>
    (event) => @props.onChange(id, event.target.checked)

  render: ->
    { value, cards, excluded, type } = @props
    <FormGroup row>
      {
        for id, info of cards when info.type is type
          <FormControlLabel
            key={id}
            control={
              <Checkbox
                checked={id in value}
                disabled={excluded? and id in excluded}
                onChange={@makeChangeHandler(id)}
                value={id}
              />
            }
            label={info.name}
          />
      }
    </FormGroup>

class MultipleCardChooser extends Component
  constructor: (props) ->
    super(props)
    @state =
      currentTab: 0
    return

  handleChangeTab: (event, currentTab) =>
    @setState({ currentTab });
    return

  render: ->
    { value, cards, types, excluded, onChange } = @props
    tabIds = (id for id of types)
    tabIndex = if @state.currentTab >= 0 and @state.currentTab < tabIds.length then @state.currentTab else 0
    tabId = tabIds[tabIndex]

    <div>
      <AppBar position="static">
        <Tabs value={tabIndex} onChange={@handleChangeTab}>
          {<Tab key={id} label={types[id].title} /> for id in tabIds}
        </Tabs>
      </AppBar>
      <CardChoices value={value} cards={cards} excluded={excluded} type={tabId} onChange={onChange} />
      <b>Selected Cards:</b>
      <CardList selected={value} cards={cards} types={types} />
    </div>

export default MultipleCardChooser
