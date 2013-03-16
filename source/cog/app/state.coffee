events= require '../events'
HashManager= require './hashmgr'

class State 
  events.mixin @, @::
  hashMgr= new HashManager

  constructor: (defaultStates)->
    @modes= {}
    @listenTo hashMgr, 'change', @hashDidChange

  hashDidChange: (hashData)=>
    # extract the data I care about...

  addState: (name, defaultVal)->

  set: (stateHash)->

  get: (name) ->

module.exports= State