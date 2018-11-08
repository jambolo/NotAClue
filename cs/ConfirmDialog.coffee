`
import React, { Component } from 'react';

import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
`

class ConfirmDialog extends Component
  handleYes: =>
    console.log("ConfirmDialog::handleYes")
    @props.onClose()
    @props.yesAction() if @props.yesAction?

  handleNo: =>
    console.log("ConfirmDialog::handleNo")
    @props.onClose()
    @props.noAction() if @props.noAction?

  render: ->
    <Dialog open={@props.open} onClose={@props.onClose}>
      <DialogTitle id="form-dialog-title">Please Confirm</DialogTitle>
      <DialogContent>
        <DialogContentText>
          {@props.question}
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        {<Button variant="contained" color="primary" onClick={@handleNo}>{if @props.yesAction? then "No" else "Cancel"}</Button> if @props.noAction?}
        {<Button variant="contained" color="primary" onClick={@handleYes}>{if @props.noAction? then "Yes" else "Ok"}</Button> if @props.yesAction?}
      </DialogActions>
    </Dialog>

export default ConfirmDialog
