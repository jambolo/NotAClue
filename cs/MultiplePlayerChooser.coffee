`
import Checkbox from '@material-ui/core/Checkbox';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import FormGroup from '@material-ui/core/FormGroup';
import React, {Component} from 'react';
`

class MultiplePlayerChooser extends Component
  handleChangeCards: (playerId) =>
    (event) =>
      console.log("MultiplePlayerChooser::handleChangePlayers: (#{playerId}, #{event.target.checked})")
      @props.onChange(playerId, event.target.checked);

  render: ->
    { value, playerIds, excluded } = @props
    <FormGroup row>
      {(
        for id in playerIds
          <FormControlLabel
            key={id}
            value={id}
            control={
              <Checkbox
                checked={id in value}
                disabled={id in excluded}
                onChange={@handleChangeCards(id)}
                value={id}
              />
            } label={id}
          />
      )}
    </FormGroup>

export default MultiplePlayerChooser
