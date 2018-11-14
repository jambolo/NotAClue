`
import React, { Component } from 'react';

import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import Divider from '@material-ui/core/Divider';
`

class ShowDialog extends Component
  handleDone: =>
#    console.log("ShowDialog::handleDone")
    @props.onClose()

  handleCancel: =>
#    console.log("ShowDialog::handleCancel")
    @props.onClose()

  render: ->
    <Dialog open={@props.open} onClose={@props.onClose}>
      <DialogTitle id="form-dialog-title">Record Shown Cards</DialogTitle>
      <DialogContent>
        <DialogContentText>
          Do stuff
        </DialogContentText>
        <Divider />
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}>Cancel</Button>
        <Button variant="contained" color="primary" onClick={@handleDone}>Done</Button>
      </DialogActions>
    </Dialog>

export default ShowDialog
