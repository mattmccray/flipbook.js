events= require './events'
extend= require 'util/extend'

class Cog
  events.mixin @::

  constructor: (data={})->
    # @originalAttrs= data
    extend @, data

  # obj.get('key') is really the same as obj.key
  get: (key, defaultVal)->
    @[key] ? defaultVal

  toggle: (key, value)->
    if typeof value is 'boolean'
      @set key, value
    else
      @set key, (not @get(key))
    @

  # You can use obj.key='name', but by using obj.set 'key', 'name'
  # (or obj.set key:'name'), the object will emit a 'change:key'
  # and 'change' events
  set: (keyOrHash, value)->
    changed=[]
    if typeof keyOrHash is 'string'
      if @[keyOrHash] isnt value
        @[keyOrHash]= value
        changed.push keyOrHash
        @fire "change:#{ keyOrHash }", value, @
    else
      for key, val of keyOrHash
        if @[key] isnt val
          @[key]= val
          changed.push key
          @fire "change:#{ key }", val, @
    @fire 'change', changed, @ if changed.length
    @

  # hasChanged: (key)->
  #   Check @originalAttrs to @ for key

  # previousValue: (key)->
    # @originalAttrs[key]

  # toJSON: ->
  #   obj={}
  #   for k, v of @.constructor.attributes
  #     obj[k]= @[k]
  #   obj

module.exports= Cog