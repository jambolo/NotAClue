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
    @props.yesAction() if @props.yesAction?
    @props.onClose()
    return

  handleNo: =>
    @props.noAction() if @props.noAction?
    @props.onClose()
    return

  render: ->
    { open, title, question, yesAction, noAction } = @props
    <Dialog disableBackdropClick={true} disableEscapeKeyDown={true} open={open} onClose={@handleNo}>
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
