`
import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import Input from '@material-ui/core/Input';
import React from 'react';
import Typography from '@material-ui/core/Typography'
`

ExportDialog = (props) ->
    { open, log, onClose } = props
    <Dialog open={open} fullscreen="true" disableBackdropClick={true} onClose={onClose}>
      <DialogTitle id="form-dialog-title"> Export </DialogTitle>
      <DialogContent>
        <Typography component="h6"> Copy the JSON-formatted text below: </Typography>
        <Input autofocus={true} fullwidth={true} multiline={true} value={JSON.stringify(log)} />        
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={onClose}> Done </Button>
      </DialogActions>
    </Dialog>

export default ExportDialog
