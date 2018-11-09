`
import React from 'react';

import FormControlLabel from '@material-ui/core/FormControlLabel';
import FormControl from '@material-ui/core/FormControl';
import FormLabel from '@material-ui/core/FormLabel';
import Radio from '@material-ui/core/Radio';
import RadioGroup from '@material-ui/core/RadioGroup';
`

PlayerChoices = (props) ->
  <RadioGroup row name="versions" value={props.playerId} onChange={props.onChange}>
    {(<FormControlLabel key={id} value={id} control={<Radio /> } label={id} /> for id in props.playerIds)}
  </RadioGroup>

PlayerChooser = (props) ->
    <FormControl component="fieldset">
      <FormLabel component="legend">Select a player:</FormLabel>
      <PlayerChoices
        playerId={props.playerId}
        playerIds={props.playerIds}
        onChange={(event) -> props.onChange(event.target.value)}
      />
    </FormControl>

export default PlayerChooser
