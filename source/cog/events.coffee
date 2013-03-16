class Events
  @mixin: (targets...)->
    for target in targets
      target[name]= fn for name,fn of @::
    return @

  emit: (event, args...) ->
    return false unless @_events?[event]
    listener args... for listener in @_events[event]
    return true
  
  trigger: @::emit
  fire: @::emit

  addListener: (event, listener) ->
    @emit 'newListener', event, listener
    ((@_events?={})[event]?=[]).push listener
    return @

  on: @::addListener

  once: (event, listener) ->
    fn = =>
      @removeListener event, fn
      listener arguments...
    @on event, fn
    return @

  removeListener: (event, listener) ->
    return @ unless @_events?[event]
    @_events[event] = (l for l in @_events[event] when l isnt listener)
    return @

  off: @::removeListener

  removeAllListeners: (event) ->
    delete @_events[event] if @_events?
    return @

  listeners: (event)->
    if @_events?[event] then @events[event] else []


# class Listener
#   @mixin: (target)->
#     target[name]= fn for name,fn of @::
#     return @

  listenTo: (emitter, event, callback)->
    return @ unless emitter? and event? and callback?
    id= (emitter._emitterId ?= uid())
    (@_emitterBindings ?= {})[id]?=[] 
    @_emitterBindings[id].push target:emitter, message:event, action:callback
    emitter.on event, callback
    return @

  # All args are optional
  stopListening: (emitter, event, callback)->
    return @ unless @_emitterBindings?
    if emitter is null # Stop listening to all
      for id, binding of @_emitterBindings
        {target, message, action}= binding
        target.off message, action
      @_emitterBindings={}
    
    else 
      bindings= @_emitterBindings[emitter._emitterId]
      return @ unless binding?
      removed= []

      if event is null # Stop listening to all on emitter
        while binding = bindings.pop()
          {target, message, action}= binding
          target.off message, action

      else if callback is null # Stop listening to event on emitter
        for binding in bindings when binding.message is event
          {target, message, action}= binding
          target.off message, action
          removed.push binding

      else # Stop listening to event on emitter with specific callback
        for binding in bindings when binding.message is event and binding.action is callback
          {target, message, action}= binding
          target.off message, action
          removed.push binding

      if removed.length > 0
        @_emitterBindings[emitter._emitterId]= arrayWithout(bindings, removed)
    
    return @

module.exports= Events 
# {Events, Listener}
