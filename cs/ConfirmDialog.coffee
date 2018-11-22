`
import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import React, { Component } from 'react';
`

class ConfirmDialog extends Component
  handleYes: =>
    @props.onClose()
    @props.yesAction() if @props.yesAction?

  handleNo: =>
    @props.onClose()
    @props.noAction() if @props.noAction?

  render: ->
    { open, title, question, yesAction, noAction } = @props
    <Dialog disableBackdropClick disableEscapeKeyDown open={open} onClose={@handleNo}>
      <DialogTitle id="form-dialog-title">{title}</DialogTitle>
      <DialogContent>
        <DialogContentText>
          {question}
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        {<Button variant="contained" color="primary" onClick={@handleNo}>{if yesAction? then "No" else "Cancel"}</Button> if noAction?}
        {<Button variant="contained" color="primary" onClick={@handleYes}>{if noAction? then "Yes" else "Ok"}</Button> if yesAction? or not noAction}
      </DialogActions>
    </Dialog>

export default ConfirmDialog
