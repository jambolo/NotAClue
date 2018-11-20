`
import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemText from '@material-ui/core/ListItemText';
import React, { Component } from 'react';
`

cardPhrase = (card, configuration, usePreposition = true) ->
  type = configuration.types[card.type]
  phrase = ""
  phrase += type.preposition + " " if usePreposition and type.preposition.length > 0
  phrase += type.article + " " if type.article.length > 0
  phrase += card.name
  return phrase

transcribedList = (list) ->
  string = list[0]
  if list.length > 1
    if list.length > 2
      for i in list[1...-1]
        string += ", " + i
      string += ", and " + list[list.length-1]
    else
      string += " and " + list[1]
  return string

playerList = (playerIds) ->
  return transcribedList(playerIds)    

cardList = (cardIds, configuration) ->
  cards = configuration.cards
  names = (cardPhrase(cards[id], configuration, false) for id in cardIds)
  return transcribedList(names)

suggestedCardsClause = (cardIds, configuration) ->
  cards = configuration.cards
  suggestionOrder = configuration.suggestionOrder
  card1 = (cards[id] for id in cardIds when cards[id].type is suggestionOrder[0])[0]
  card2 = (cards[id] for id in cardIds when cards[id].type is suggestionOrder[1])[0]
  card3 = (cards[id] for id in cardIds when cards[id].type is suggestionOrder[2])[0]
  clause = cardPhrase(card1, configuration) + " "
  clause += cardPhrase(card2, configuration) + " " 
  clause += cardPhrase(card3, configuration)
  return clause

class LogDialog extends Component
  constructor: (props) ->
    super(props)
    @configuration = null

  describeSetup: (info) =>
    "Playing #{@configuration.name} with #{playerList(info.players)}."

  describeHand: (info) =>
    "#{info.player} has #{cardList(info.cards, @configuration)}."

  describeSuggest: (info) =>
    "#{info.suggester} suggested #{suggestedCardsClause(info.cards, @configuration)}. #{playerList(info.showed)} showed a card."

  describeShow: (info) =>
    cards = @configuration.cards
    "#{info.player} showed #{cardPhrase(cards[info.card], @configuration, false)}."

  describeEntry: (entry) =>
    if entry.setup?
      @describeSetup(entry.setup)
    else if entry.hand?
      @describeHand(entry.hand)
    else if entry.suggest?
      @describeSuggest(entry.suggest)
    else if entry.show?
      @describeShow(entry.show)
    else
      alert("Unknown log entry")

  render: ->
    @configuration = if @props.log[0]? then @props.configurations[@props.log[0].setup.variation] else null

    <Dialog open={@props.open} fullscreen="true" onClose={@props.onClose}>
      <DialogTitle id="form-dialog-title">Log</DialogTitle>
      <DialogContent>
        <DialogContentText>
          <List component="ol" dense>
            {(
              <ListItem ><ListItemText primary={@describeEntry(entry)} /></ListItem> for entry in @props.log
            )}
          </List>
        </DialogContentText>
     </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@props.onClose}>Done</Button>
      </DialogActions>
    </Dialog>

export default LogDialog
