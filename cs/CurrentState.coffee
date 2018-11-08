`
import React, { Component } from 'react';

import Button from '@material-ui/core/Button';
import Checkbox from '@material-ui/core/Checkbox';
`

StateElement = (props) ->
  if props.card.isHeldBy props.player
    return <Checkbox checked color="primary" />
  else if props.card.mightBeHeldBy props.player
    return <Checkbox disabled checked />
  else
    return <Checkbox disabled />

StateRow = (props) ->
  <div>
    {props.card.info.name}
    {(<StateElement key={player} card={props.card} player={player} /> for player of props.players)}
  </div>

StateGrid = (props) ->
  <div>
    {(<StateRow key={id} card={card} players={props.players} /> for id, card of props.cards)}
  </div>

class CurrentState extends Component
  render: ->
    <div>
      <Button variant="contained" color="primary" onClick={@props.app.showHandDialog}>Hand</Button>
      <Button variant="contained" color="primary" onClick={@props.app.showSuggestDialog}>Suggest</Button>
      <Button variant="contained" color="primary" onClick={@props.app.showShowDialog}>Show</Button>
      <hr />
      <StateGrid cards={@props.solver.cards} players={@props.solver.players} />
    </div>

export default CurrentState
