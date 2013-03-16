events= require './events'
StateManager= require './app/state'

class App
  events.mixin @, @::
  constructor: ->
    @_commands= {}
    @_providers= {}
    @_state= new StateManager @.constructor._states ? {}
    @listenTo @_state, 'change:state', (state, value)=>
      fireEvent @, 'change:state', state, value

  state: (key, value)->
    if key is null
      @_state.modes

  @state: (name, defaultVal)->
    @_states[name]= defaultVal
    @
  @states: (hash)->
    for k, v of hash
      @state k, v
    @

  execute: (command, args...)->
    # Only one handler allowed!
    @_commands[command]?(args...)

  addCommand: (command, handler)->
    @_commands[command]= handler
    
  request: (name)->
    # Should this be a method invocation or not?
    @_providers[name]?()

  addProvider: (name, handler)->
    @_providers[name]= handler


  @start: (options={})->
    new @ options





module.exports= App

