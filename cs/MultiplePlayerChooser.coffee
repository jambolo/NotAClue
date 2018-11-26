`
import Checkbox from '@material-ui/core/Checkbox';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import FormGroup from '@material-ui/core/FormGroup';
import React, {Component} from 'react';
`

class MultiplePlayerChooser extends Component

  makeChangeHandler: (id) =>
    (event) => @props.onChange(id, event.target.checked)

  render:->
    { value, players, excluded } = @props
    <FormGroup row>
      {
        for id in players
          <FormControlLabel
            key={id}
            value={id}
            control={
              <Checkbox
                checked={id in value}
                disabled={excluded? and id in excluded}
                onChange={@makeChangeHandler(id)}
                value={id}
              />
            } label={id}
          />
      }
    </FormGroup>

export default MultiplePlayerChooser
