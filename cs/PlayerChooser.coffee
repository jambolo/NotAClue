`
import FormControl from '@material-ui/core/FormControl';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import Radio from '@material-ui/core/Radio';
import RadioGroup from '@material-ui/core/RadioGroup';
import React from 'react';
`

PlayerChoices = (props) ->
  { value, players, onChange } = props
  <RadioGroup row name="players" value={value} onChange={onChange}>
    {
      for id in players
        <FormControlLabel 
          key={id} 
          value={id} 
          control={<Radio />} 
          label={id} 
        /> 
    }
  </RadioGroup>

PlayerChooser = (props) ->
  { value, players, onChange } = props
  <FormControl component="fieldset">
    <PlayerChoices
      value={value}
      players={players}
      onChange={(event) -> onChange(event.target.value)}
    />
  </FormControl>

export default PlayerChooser
