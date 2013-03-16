events= require '../events'

class HashManager
  events.mixin @, @::

  constructor: ->
    @parseHash()
    @setupListener()
    console.log "EVENTS", @

  parseHash: ->

  setupListener: ->

  recognize: ->

module.exports= HashManager