`
import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import React, { Component } from 'react';
import TextField from '@material-ui/core/TextField';
import Typography from '@material-ui/core/Typography'
`

class ImportDialog extends Component
  constructor: (props) ->
    super(props)
    @state = 
      imported: ""
    return

  close: ->
    @setState({ imported: "" })   
    @props.onClose()
    return

  handleClose: =>
    @close()
    return

  handleChange: (event) =>
    @setState({ imported: event.target.value })
    return

  handleCancel: =>
    @close()
    return

  handleDone: =>
    @props.onDone(@state.imported)
    @close()
    return

  render: ->
    { open } = @props
    <Dialog open={open} fullscreen="true" disableBackdropClick={true} onClose={@handleClose}>
      <DialogTitle id="form-dialog-title"> Import </DialogTitle>
      <DialogContent>
      <Typography variant="h6"> Paste an exported log into the text field below: </Typography>
      <TextField 
        autoFocus 
        fullWidth={true}
        margin="normal"
        multiline={true}
        onChange={@handleChange}
        placeholder="Paste here."
        value={@state.imported} 
        variant="outlined"
      />
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="primary" onClick={@handleCancel}> Cancel </Button>
        <Button disabled={@state.imported.length == 0} variant="contained" color="primary" onClick={@handleDone}>
          Done
        </Button>
      </DialogActions>
    </Dialog>

export default ImportDialog
