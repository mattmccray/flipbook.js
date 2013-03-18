events= require './events'
extend= require 'util/extend'
defaults= require 'util/defaults'

CogObject= require './object'

class Model extends CogObject
  events.mixin @, @::

  @attr: (name, options)->
    (@attributes?={})[name]= options # validate options
    @
  @attrs: (hash)->
    for key, value of hash
      @attr key, value
    @

  constructor: (data={})->
    @originalAttrs= data
    extend @, data

  # obj.get('key') is really the same as obj.key
  get: (key, defaultVal)->
    @[key] or defaultVal

  # You can use obj.key='name', but by using obj.set 'key', 'name'
  # (or obj.set key:'name'), the object will emit a 'change:key'
  # event
  set: (keyOrHash, value)->
    if typeof keyOrHash is 'string'
      @[keyOrHash]= value
      fireEvent @, "change:#{ key }", value
    else
      for key, value of object
        @[key]= value
        fireEvent @, "change:#{ key }", value
    changed= @changedAttrs()
    fireEvent @, 'change', changed
    # Should a generic 'change' event be fired too?
    @

  save: (done)->
    fireEvent @, 'saving'
    changed= @changedAttrs()
    Store.sync 'save', @, changed, (err)=>
      return @emit 'error', err if err?
      fireEvent @, 'save'
      fireEvent @, 'change', changed
      @originalAttrs= @toJSON()
      done()

  destroy: (done)->
    fireEvent @, 'destroying'
    Store.sync 'destory', @, (err)=>
      return fireEvent( @, 'error', err ) if err?
      fireEvent @, 'destroy'
      done()

  isDirty: ->
    # Check @originalAttrs to @
  
  hasChanged: (key)->
    # Check @originalAttrs to @ for key

  changedAttrs: ->
    # comparing @originalAttrs to @
    return {}

  toJSON: ->
    obj={}
    for k, v of @.constructor.attributes
      obj[k]= @[k]
    obj

class MyModel extends Model
  @attrs
    name: String

module.exports= Model