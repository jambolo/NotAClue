`
import Grid from '@material-ui/core/Grid';
import Icon from '@material-ui/core/Icon';
import React from 'react';
`

Yes = (props) ->
  <Icon>
    {if props.player is "ANSWER" then "star" else "check_box"}
  </Icon>

No = (props) ->
  ""

Maybe = (props) ->
  <Icon color="disabled">indeterminate_check_box</Icon>

StateElement = (props) ->
  { card, player } = props

  if card.isHeldBy player
    <Yes player={player} />
  else if card.mightBeHeldBy player
    <Maybe />
  else
    <No />

HeaderRow = (props) ->
  { players } = props

  <Grid container item xs={12} justify="center">
    <Grid item xs={4}><b>Card</b></Grid>
    {<Grid item key={playerId} xs={1}><b>{playerId}</b></Grid> for playerId of players}
  </Grid>

StateRow = (props) ->
  {card, players} = props

  <Grid container item xs={12} justify="center">
    <Grid item xs={4}>
      {card.info.name}
    </Grid>
    {
      for playerId of players
        <Grid 
          item 
          key={playerId} 
          xs={1}> 
          <StateElement card={card} player={playerId} /> 
        </Grid> 
    }
  </Grid>

CurrentState = (props) ->
  { cards, players } = props.solver

  <Grid container>
    <HeaderRow players={players} />
    {<StateRow key={id} card={card} players={players} /> for id, card of cards}
  </Grid>

export default CurrentState
