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
    changed={}
    hasChanged= no
    if typeof keyOrHash is 'string'
      if @[keyOrHash] isnt value
        oldval= @[keyOrHash]
        @[keyOrHash]= value
        changed[keyOrHash]= value
        changed["#{keyOrHash}Previous"]= oldval
        hasChanged= yes
        @fire "change:#{ keyOrHash }", value, oldval, @
    else
      for key, val of keyOrHash
        if @[key] isnt val
          oldval= @[key]
          @[key]= val
          changed[key]= val
          changed["#{key}Previous"]= oldval
          hasChanged= yes
          @fire "change:#{ key }", val, oldval, @
    @fire 'change', changed, @ if hasChanged
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