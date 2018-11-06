`
import React, { Component } from 'react';
import {
  BrowserRouter as Router,
  Route,
  Switch
} from 'react-router-dom'
import './App.css'
import Home from './Home'
import About from './About'
`

class App extends Component
  render: ->
    <Router>
      <div className="App">
        <p>
          Not A Clue
        </p>
        <Switch>
          <Route exact path="/" component={ Home } />
          <Route path="/about" component={ About } />
        </Switch>
      </div>
    </Router>

export default App
