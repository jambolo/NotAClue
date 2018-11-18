`
import Button from '@material-ui/core/Button';
import Grid from '@material-ui/core/Grid';
import Icon from '@material-ui/core/Icon';
import React, { Component } from 'react';
`

Yes = (props) ->
  <Icon>
    {if props.playerId is "ANSWER" then "star" else "check_box"}
  </Icon>

No = (props) ->
  ""

Maybe = (props) ->
  <Icon color="disabled">indeterminate_check_box</Icon>

StateElement = (props) ->
  {card, playerId} = props

  if card.isHeldBy playerId
    <Yes playerId={playerId} />
  else if card.mightBeHeldBy playerId
    <Maybe playerId={playerId} />
  else
    <No playerId={playerId} />

HeaderRow = (props) ->
  { players } = props

  <Grid container item xs={12} justify="center">
    <Grid item xs={4}><h4>Card</h4></Grid>
    {(<Grid item key={playerId} xs={1}><h4>{playerId}</h4></Grid> for playerId of players)}
  </Grid>

StateRow = (props) ->
  {card, players} = props

  <Grid container item xs={12} justify="center">
    <Grid item xs={4}>
      {card.info.name}
    </Grid>
    {(
      for playerId of players
        <Grid 
          item 
          key={playerId} 
          xs={1}> 
          <StateElement card={card} playerId={playerId} /> 
        </Grid> 
    )}
  </Grid>

StateGrid = (props) ->
  {cards, players} = props

  <Grid container>
    <HeaderRow players={players} />
    {(<StateRow key={id} card={card} players={players} /> for id, card of cards)}
  </Grid>

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
