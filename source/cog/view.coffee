events= require './events'
uid= require 'util/uid'

class View
  events.mixin @, @::

  tagName: 'div'
  className: 'view'

  template: null
  events: {}
  outlets: {}

  constructor: (@options={})->
    @id= uid('view-')
    @model= @options.model ? {}
    @_createElem()
    @assignEvents()
    @initialize?()

  _createElem: ->
    if @options.elem?
      @elem= $ @options.elem
    else
      @elem= $ "<#{ @tagName } class='#{ @className }'></#{ @tagName }>"

  assignEvents: ->
    for evt, callback of @events
      eparts= evt.split ' '
      if eparts.length > 1
        evt= eparts.shift()
        sel= eparts.join(' ')
        @elem.on evt, sel, @[callback]
      else
        @elem.on evt, @[callback]
    @
  unassignEvents: ->
    for evt, callback of @events
      eparts= evt.split ' '
      if eparts.length > 1
        evt= eparts.shift()
        sel= eparts.join(' ')
        @elem.off evt, sel, @[callback]
      else
        @elem.off evt, @[callback]
    @

  assignOutlets: ->
    @ui={}
    for outlet, sel of @outlets
      @ui[outlet]= @elem.find sel
      # TODO: Decide whether to do this or not?
      @[outlet]= @elem.find sel
    @
  unassignOutlets: ->
    for outlet, elem of @ui
      delete @ui[outlet]
      # Uh... Bad idea?
      delete @[outlet] 
    @

  dispose: ->
    @unassignEvents()
    @unassignOutlets()
    @
  
  close: ->
    @beforeClose?()
    @dispose()
    @elem.remove()
    @onClose?()
    @

  getData: ->
    @model.toJSON?() ? @model

  appendTo: (elem)->
    @render()
    elem.append(@elem)
    @onDomActive?()

  addView: (outlet, view)->
  replaceView: @::addView

  appendView: (outlet, view)->

  render: ->
    @beforeRender?()
    @fire 'before:render', @
    data = @getData()
    html = @template(data)
    @elem.html(html)
    @assignOutlets()
    @fire 'render', @
    @onRender?()
    @




module.exports= View