events= require './events'

extend= (obj)->
  for source in Array::slice.call(arguments, 1)
    if source
      for key,value of source
        obj[key]= value
  obj


class Cog
  events.mixin @::

  constructor: (data={})->
    # @originalAttrs= data
    @_previous= {}
    extend @, data

  # obj.get('key') is really the same as obj.key but it will call
  #  obj.key() if it exists
  get: (key, defaultVal)->
    @[key]?() ? @[key] ? defaultVal

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
    changed= {}
    hasChanged= no
    if typeof keyOrHash is 'string'
      if @[keyOrHash] isnt value
        oldval= @[keyOrHash]
        @[keyOrHash]= value
        changed[keyOrHash]= value
        @_previous[keyOrHash]= oldval
        # changed["#{keyOrHash}Previous"]= oldval
        hasChanged= yes
        @fire "change:#{ keyOrHash }", value, oldval, @
    else
      for key, val of keyOrHash
        if @[key] isnt val
          oldval= @[key]
          @[key]= val
          changed[key]= val
          @_previous[key]= oldval
          # changed["#{key}Previous"]= oldval
          hasChanged= yes
          @fire "change:#{ key }", val, oldval, @
    @fire 'change', changed, @ if hasChanged
    @_previous= {}
    @

  hasChanged: (key)->
    `(key in this._previous)`

  previous: (key)->
    @_previous[key] ? null


module.exports= Cog