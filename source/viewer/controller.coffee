uid= require 'util/uid'
log= require('util/log').prefix('controller:')
events= require 'cog/events'
CogView= require 'cog/view'
class BaseView
  constructor: (@options={})->
    @id= uid('view-')
    @elem= @options.elem
    # @assignOutlets()
    @initialize?()

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
      @[outlet]= @elem.find sel
    @

  unassignOutlets: ->
    for outlet,elem of @ui
      delete @ui[outlet]
    @

nextKeys= [39, 32]
prevKeys= [37]



class Viewer extends CogView

  className: 'flipbook'

  template: require('./template')

  events:
    'click .nextPage': 'nextPage'
    'click .prevPage': 'prevPage'
    'click .screen img': 'prevPage'

  outlets:
    stack: '.screen-stack'

  initialize: ->
    @screenCount= parseInt(@model.pages)
    @current= 0
    @ready= no

  onKeyInput: (e)=>
    return unless @ready
    if e.which in nextKeys
      @nextPage(e)
      false
    else if e.which in prevKeys
      @prevPage(e)
      false

  nextPage: (e)=>
    e?.preventDefault?()
    return if @current is @screenCount - 1
    @hideCurrent()
    @current += 1
    @showCurrent()

  prevPage: (e)=>
    e?.preventDefault?()
    return if @current is 0
    @hideCurrent()
    @current -= 1
    @showCurrent()

  loadCheck: ->
    if @loadCount is @screenCount
      @showCurrent()
      height= @stack.show().find('img').height()
      @stack.find('.screen').hide()
      @showCurrent()
      # log.info "resizing to", height
      @stack
        .css(opacity:0)
        .animate(height:height, opacity:1)
      @ready= yes

  imageDidLoad: (e)=>
    @loadCount += 1
    idx= $(e.target).data('idx')
    @elem.find("span[data-idx=#{ idx }]").removeClass('loading').addClass('loaded')
    @loadCheck()

  imageDidError: (e)=>
    log.info "ERROR"
    @loadCount += 1
    $(e.target).removeClass('loading').addClass('error')
    @loadCheck()

  showCurrent: ->
    $(@stack.find('.screen').get(@current)).show()
    @elem.find("span[data-idx=#{ @current }]").addClass 'current'

  hideCurrent: ->
    $(@stack.find('.screen').get(@current)).hide()
    @elem.find("span[data-idx=#{ @current }]").removeClass 'current'

  getData: ->
    screens= []
    for i in [1..@screenCount]
      screens.push src:"media/comics/#{i}.jpg"
    data= @model
    data.screens= screens
    data.id= @id
    data

  onRender: ->
    @loadCount= 0
    @elem
      .find('img')
      .on( 'load', @imageDidLoad )
      .on( 'error', @imageDidError )
    $(document).on 'keydown', @onKeyInput



module.exports= Viewer