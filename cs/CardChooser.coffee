`
import AppBar from '@material-ui/core/AppBar';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import FormGroup from '@material-ui/core/FormGroup';
import Tab from '@material-ui/core/Tab';
import Tabs from '@material-ui/core/Tabs';

import React, { Component } from 'react';
`

CardChoices = (props) ->
  console.log("CardChoices (render): (#{props.value}, #{props.type})")
  <RadioGroup row name="cards" value=(props.value) onChange={props.onChange}>
    {(
      for id, info of props.cards when info.type is props.type
        <FormControlLabel
          key={id}
          control={<Radio />} 
          label={info.name}
        />
    )}
  </RadioGroup>

class CardChooser extends Component
  constructor: (props) ->
    super(props)
    @state =
      currentTab: 0

  handleChangeTab: (event, currentTab) =>
    console.log("CardChooser::handleChangeTab: (event, #{currentTab})")
    @setState({ currentTab });

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
      <FormControl component="fieldset">
        <CardChoices value={value} type={tabIds[tabIndex]} onChange={(event) -> props.onChange(event.target.value)} />
      </FormControl>
    </div>

export default CardChooser
