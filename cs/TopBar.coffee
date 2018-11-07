`
import React, { Component } from 'react';

import AppBar from '@material-ui/core/AppBar';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
`
#import { withStyles } from '@material-ui/core/styles';

class TopBar extends Component
  constructor: (props) ->
    super(props)
    
  handleMainMenu: (event) =>
    console.log("TopBar::handleMainMenu")

  render: ->
    <div>
      <AppBar position="static">
        <Toolbar>
          <IconButton color="inherit" aria-label="Menu" onClick={@handleMainMenu}>
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" color="inherit">
            Not A Clue
          </Typography>
        </Toolbar>
      </AppBar>
    </div>

export default TopBar
