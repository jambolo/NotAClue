`
import React, { Component } from 'react';

import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
`

class SuggestDialog extends Component
  handleDone: =>
#    console.log("SuggestDialog::handleDone")
    @props.onClose()

  handleCancel: =>
#    console.log("SuggestDialog::handleCancel")
    @props.onClose()

  render: ->
    <Dialog open={@props.open} onClose={@props.onClose}>
      <DialogTitle id="form-dialog-title">Record Suggestion</DialogTitle>
      <DialogContent>
        <DialogContentText>
          Do stuff
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}>Cancel</Button>
        <Button variant="contained" color="primary" onClick={@handleDone}>Done</Button>
      </DialogActions>
    </Dialog>

export default SuggestDialog
