`
import React from 'react';

import MainMenu from './MainMenu'

import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
`
#import { withStyles } from '@material-ui/core/styles';

TopBar = (props) ->
  <AppBar position="static">
    <Toolbar>
      <MainMenu
        configurations={props.configurations}
        players={props.players}
        configuration={props.configuration}
        onNewGame={props.onNewGame}
        onClearGame={props.onClearGame}
      />
      <Typography variant="h6" color="inherit">
        Not A Clue
      </Typography>
    </Toolbar>
  </AppBar>

export default TopBar
