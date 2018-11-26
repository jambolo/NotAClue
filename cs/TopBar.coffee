`
import AppBar from '@material-ui/core/AppBar';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import React from 'react';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
`

TopBar = (props) ->
  <AppBar position="static">
    <Toolbar>
      <IconButton color="inherit" onClick={(event) => props.app.showMainMenu(event.currentTarget)}>
        <MenuIcon />
      </IconButton>
      <Typography variant="h6" color="inherit">
        Not A Clue
      </Typography>
    </Toolbar>
  </AppBar>

export default TopBar
