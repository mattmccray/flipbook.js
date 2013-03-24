###
  Viewer
    - handles commands
    - triggers commands
    - changes state
    - changes dom (if need be)
  Module
    - triggers commands
    - changes state
    - changes dom (if need be)
###
env= require 'env'
uid= require 'util/uid'
pad= require 'util/number/pad'
log= require('util/log').prefix('viewer:')
events= require 'cog/events'
defaults= require 'util/defaults'
validate= require './validator'
lifecycle= require 'lifecycle'
CogView= require 'cog/view'
CogModel= require 'cog/object'
{getX}= require 'util/positions'

build_url= (pattern, idx)->
  #hack!
  pattern= pattern.replace('####', pad(idx, 4))
  pattern= pattern.replace('###', pad(idx, 3))
  pattern= pattern.replace('##', pad(idx, 2))
  pattern= pattern.replace('#', idx)

class ViewState extends CogModel
  isLastPage:  -> @currentPage is @getLastPage()
  isFirstPage: -> @currentPage is 0
  getNextPage: -> Math.min (@currentPage + 1), @getLastPage()
  getPrevPage: -> Math.max (@currentPage - 1 ), 0
  getLastPage: -> @pages - 1
  isValidPage: (num) -> num >= 0 and num < @pages
  getPercentageRead: -> 
    if @currentPage is 0
      0
    else if @isLastPage()
      100
    else 
      Math.min Math.round( (@currentPage / @getLastPage()) * 100 ), 100


class FlipBookViewer extends CogView
  className: 'flipbook'
  template: require('./template')

  outlets:
    stack: '.screen-stack'
    pagerArea: '.pager'
    progressBar: '.progress'

  constructor: (options)->
    super model:options

  initialize: ->
    unless validate(@model, true)
      throw "Invalid settings: #{ validate.errors() }" 
    @elem
      .hide()
      .data 'controller', @
    @screenCount= @model.pages
    @state= new ViewState @model
    @state.set 
      controller: @
      currentPage: 0
      ready: no
      active: no
      loaded: no
      zoomed: no
      endScreen: no
      helpScreen: no
      contentScreenVisible: no

    # @state.on 'change', (changes)=> log.info changes

    @state.on 'cmd:page:next', @onNextPage
    @state.on 'cmd:page:prev', @onPrevPage
    @state.on 'cmd:zoom:toggle', @toggleZoom
    @state.on 'cmd:zoom:out', @doZoomOut
    @state.on 'cmd:zoom:in', @doZoomIn
    @state.on 'load:complete', @onLoad
    @state.on 'load:error', @onLoadError
    @state.on 'ready', @onReady

    @screenCountIdx= @screenCount - 1
    @current= 0
    @elem
      .attr( 'tabindex', "0" )
      .addClass( 'inactive' ) # Allows for focus and blur events
      .toggleClass( 'isMobile', env.mobile)
      .toggleClass( 'isDesktop', (not env.mobile))
    # log.debug "State", @state
    lifecycle.fire 'created', this
  
  get: (key)->
    @state.get key

  set: (key,val)->
    @state.set key, val
    @

  focus: ->
    @elem.focus()

  toggleZoom: (e)=>
    return if not @state.ready
    @state.toggle 'zoomed'

  doZoomIn: (e)=>
    return if @state.zoomed
    @state.set zoomed:yes

  doZoomOut: (e)=>
    return if not @state.zoomed
    @state.set zoomed:no

  onNextPage: =>
    return unless @state.ready
    if @state.isLastPage()
      @state.set endScreen:yes
      # e?.stopPropagation?()
    else if @state.endScreen or @state.helpScreen
      @state.set endScreen:no, helpScreen:no
    else
      @state.set currentPage:@state.getNextPage()

  onPrevPage: =>
    return unless @state.ready
    if @state.endScreen or @state.helpScreen
      @state.set endScreen:no, helpScreen:no
    else
      @state.set currentPage:@state.getPrevPage()

  onLoad: =>
    @state.trigger 'ready'
    @state.set ready:yes

  onReady: =>
    # log.info 'onReady'
    @state.trigger 'cmd:current:show'
    @state.trigger 'sizes:calc'
    # log.info 'resizing stack'
    @state.trigger 'resize'
    if @state.animated is false
      @stack
        .css(height:@state.imageHeight, opacity:1)
    else
      @stack
        .css(opacity:0)
        .animate height:@state.imageHeight, opacity:1 #, => @state.trigger 'resize'

  onLoadError: =>
    log.info "ERROR Loading images"
    @elem.addClass('errors')
    @stack.find('img').remove()
    err= $("<div class='errors'></div>").html(@state.loadingErrorMsg).hide()
    @stack.append(err).show()
    err.slideDown()

  showCurrent: =>
    @state.trigger 'cmd:current:show'

  hideCurrent: =>
    @state.trigger 'cmd:current:hide'

  getData: ->
    screens= []
    from= @model.start
    to= @model.start + @screenCountIdx
    for i in [from..to]
      mdl= src:build_url(@model.path, i)
      # log.info "state", mdl
      screens.push mdl
    data= defaults {}, @model
    data.screens= screens
    data.id= @id
    data.tapOrClick= ->
      if env.mobile then "tap" else "click"
    data.isMobile= env.mobile
    data

  onRender: ->
    @stack.find('.screen').hide()
    @stack.css backgroundColor:@state.background
    # log.info "Setting bg to ", @state.background
    for ctrlName in require.modules('viewer/concerns/')
      # log.debug "applying module:", ctrlName
      require(ctrlName).call @, @elem, @state


  onDomActive: ->
    if @state.animated is false
      @elem.show()
    else
      @elem.addClass 'animated'
      @elem.fadeIn()
    @elem.focus() if @model.autofocus
      

module.exports= FlipBookViewer

###
require('viewer/concerns/animated');
require('viewer/concerns/buttons');
require('viewer/concerns/end');
require('viewer/concerns/focus');
require('viewer/concerns/help');
require('viewer/concerns/keyboard');
require('viewer/concerns/loading');
require('viewer/concerns/metadata');
require('viewer/concerns/msie');
require('viewer/concerns/progress');
require('viewer/concerns/screen');
require('viewer/concerns/sizing');
require('viewer/concerns/theme');
require('viewer/concerns/zoom');
###
