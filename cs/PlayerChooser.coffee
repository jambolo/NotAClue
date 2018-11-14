`
import FormControlLabel from '@material-ui/core/FormControlLabel';
import FormControl from '@material-ui/core/FormControl';
import Radio from '@material-ui/core/Radio';
import RadioGroup from '@material-ui/core/RadioGroup';
import React from 'react';
`

PlayerChoices = (props) ->
  console.log("PlayerChoices (render): (#{props.value}, [#{props.playerIds}])")
  <RadioGroup row name="players" value={props.value} onChange={props.onChange}>
    {(<FormControlLabel key={id} value={id} control={<Radio />} label={id} /> for id in props.playerIds)}
  </RadioGroup>

PlayerChooser = (props) ->
  console.log("PlayerChoooser (render): (#{props.value}, [#{props.playerIds}])")
  <FormControl component="fieldset">
    <PlayerChoices
      value={props.value}
      playerIds={props.playerIds}
      onChange={(event) -> props.onChange(event.target.value)}
    />
  </FormControl>

export default PlayerChooser
