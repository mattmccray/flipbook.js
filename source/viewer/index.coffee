env= require 'env'
uid= require 'util/uid'
pad= require 'util/number/pad'
log= require('util/log').prefix('controller:')
events= require 'cog/events'

require('./layout').activate()

CogView= require 'cog/view'
CogModel= require 'cog/object'


getX= (e)->
  if e.offsetX?
    e.offsetX
  else 
    offset= $(e.target).offset() #.parent().offset()
    if e.gesture?
      e.gesture.center.pageX - offset.left
    else
      e.pageX - offset.left

keyListener=
  ready: no

  init: ->
    return if @ready or env.mobile
    $(document).on 'keydown', @onKeyInput
    @ready= yes

  onKeyInput: (e)->
    if Viewer.active?
      return Viewer.active.onKeyInput(e)

nextKeys= [32, 39, 68, 221]
prevKeys= [37, 65, 219]
zoomKeys= [27]

keyboardCtrl= (elem, state)->
  handler= (e)=>
    return unless state.ready and state.active
    if e.which in nextKeys
      state.trigger 'cmd:page:next'
      false
    else if e.which in prevKeys
      state.trigger 'cmd:page:prev'
      false
    else if e.which in zoomKeys
      if elem.is '.zoomed'
        @state.set zoomed:no
  null


build_url= (pattern, idx)->
  #hack!
  pattern= pattern.replace('####', pad(idx, 4))
  pattern= pattern.replace('###', pad(idx, 3))
  pattern= pattern.replace('##', pad(idx, 2))
  pattern= pattern.replace('#', idx)

setTheme= (o)->
  theme_name= "theme-#{ o.theme }"
  try
    require("./#{ theme_name }").activate()
    theme_name
  catch ex
    require("./theme-default").activate()
    "theme-default"

class ViewState extends CogModel
  isLastPage:  -> @currentPage is @getLastPage()
  isFirstPage: -> @currentPage is 0
  getNextPage: -> Math.min (@currentPage + 1), @getLastPage()
  getPrevPage: -> Math.max (@currentPage - 1 ), 0
  getLastPage: -> @pages - 1
  isValidPage: (num) -> num >= 0 and num < @pages
  getPercentageRead: -> 
    if @isLastPage()
      100
    else
      Math.min Math.ceil( ((@currentPage + 1) / @pages) * 100 ), 100


class Viewer extends CogView

  @active= null

  className: 'flipbook'

  template: require('./template')

  outlets:
    stack: '.screen-stack'
    restartBtn: '.restart'
    pagerArea: '.pager'
    progressBar: '.progress'


  initialize: ->
    @elem.data 'controller', @
    @screenCount= @model.pages
    @state= new ViewState @model
    @state.set 
      currentPage:0
      ready:no
      active:no
      loaded:no
      zoomed:no
      endScreen:no
      helpScreen:no
    # @state.on 'change', (changed)-> console.warn "state changed", changed
    @state.on 'change:currentPage', @onPageChange
    @state.on 'change:active', (isActive)=>
      Viewer.active= if isActive
        this
      else if Viewer.active is this
        null
      else
        Viewer.active
    @state.on 'cmd:page:next', @onNextPage
    @state.on 'cmd:page:prev', @onPrevPage
    @state.on 'cmd:help:toggle', @toggleHelp
    @state.on 'cmd:zoom:toggle', @toggleZoom

    @screenCountIdx= @screenCount - 1
    @current= 0
    @ready= no
    @active= no
    @showingHelp= no
    @elem
      .attr( 'tabindex', -1 )
      .addClass( 'inactive' ) # Allows for focus and blur events
      .addClass( setTheme @model )
      .toggleClass( 'isMobile', env.mobile)
      .toggleClass( 'isDesktop', (not env.mobile))
    keyListener.init()


  #FIXME: Convert to new event/command format
  fullScreen: (e)=>
    return unless @ready
    e?.preventDefault()
    @hideCurrent()
    if @elem.is '.zoomed'
      @elem.detach()
      @elem.removeClass('zoomed')
      @containingElem.append(@elem)
      @elem.css width:@imageWidth, height:''
      @stack.css(height:@imageHeight)
      @progressWidth= @progressBar.width()
      $(window).off 'resize', @resizeFullscreenElements
      @stack.find('img').css maxWidth:'100%', maxHeight:''
      @state.set zoomed:no
    else
      @elem.detach()
      @elem.addClass('zoomed')
      newParent= $('body')
      newParent.after(@elem)
      @resizeFullscreenElements()
      $(window).on 'resize', @resizeFullscreenElements
      @state.set zoomed:yes
    @elem.focus()
    @showCurrent()
  
  toggleHelp: (e)=>
    e?.preventDefault()
    return if not @ready or @state.endScreen
    @state.toggle 'helpScreen'

  toggleZoom: (e)=>
    e?.preventDefault()
    return if not @ready
    # @state.toggle 'zoomed'
    @fullScreen() # for now..

  #FIXME: Convert to new event/command format
  resizeFullscreenElements: (e)=>
    d= $(window)
    h= d.height()
    w= d.width()
    @elem.css width:w, height:h
    h -= @elem.find('.pager').outerHeight()
    h -= @elem.find('header').outerHeight()
    h -= @elem.find('.copyright').outerHeight() ? 0
    @stack.css height:h
    @stack.find('img').css maxWidth:Math.min(w, @fullImageWidth), maxHeight:Math.min(h, @fullImageHeight)
    @progressWidth= @progressBar.width()


  #FIXME: Convert to new event/command format
  triggerfullScreen: =>
    @goFullscreen= yes unless @elem.is('.zoomed')
  #FIXME: Convert to new event/command format
  triggerInline: =>
    @goInline= yes if @elem.is('.zoomed')

  #FIXME: Convert to new event/command format
  touchComplete: (e)=>
    if @goFullscreen
      @fullScreen(e)
      @goFullscreen= no
      @goInline= no
    else if @goInline
      @fullScreen(e)
      @goFullscreen= no
      @goInline= no

  #FIXME: Convert to new event/command format
  onKeyInput: (e)=>
    return unless @state.ready and @state.active
    if e.which in nextKeys
      @state.trigger 'cmd:page:next'
      false
    else if e.which in prevKeys
      @state.trigger 'cmd:page:prev'
      false
    else if e.which is 27
      if @elem.is '.zoomed'
        # @state.set zoomed:no
        @fullScreen()

  #FIXME: Convert to new event/command format
  didTap: (e)=>
    return if @state.endScreen or @state.helpScreen or not @ready
    e?.preventDefault?()
    e?.stopPropagation?()
    x= getX(e)
    if x < (@imageWidth / 2)
      @state.trigger 'cmd:page:prev'
    else
      @state.trigger 'cmd:page:next'
    false

  #FIXME: Convert to new event/command format
  didTapScrubber: (e)=>
    e?.preventDefault?()
    # e?.stopPropagation?()
    x= getX(e)
    p= (x / @progressWidth)
    page= Math.floor p * @screenCount
    page= @screenCount - 1 if page > @screenCount
    page= 0 if page < 0
    # log.info "SCRUBBER AT", x, p, page, '/', @screenCount
    @state.set currentPage:page
    # @navigateTo page

  #FIXME: Convert to new event/command format
  startScrubbing: (e)=>
    return unless @ready
    @progressBar
      .find('span')
      .hide()
      .end()
      .on('mousemove', @didTapScrubber)
    @elem
      .on('mouseleave', @stopScrubbing)
      .focus()
    $(document)
      .on('mouseup', @stopScrubbing)
    @didTapScrubber(e)
  
  #FIXME: Convert to new event/command format
  stopScrubbing: (e)=>
    @progressBar
      .find('span')
      .show()
      .end()
      .off('mousemove', @didTapScrubber)
    @elem
      .off('mouseleave', @stopScrubbing)
    $(document)
      .off('mouseup', @stopScrubbing)

  onPageChange: (idx)=>
    return @state.set currentPage:@state.getLastPage() if idx is -1
    return if not @ready or not @state.isValidPage(idx)
    @state.set endScreen:no
    @hideCurrent()
    @current = idx
    @showCurrent()

  onRestart: =>
    @state.set currentPage:0, endScreen:no, helpScreen:no    

  onNextPage: =>
    return unless @ready
    if @state.isLastPage()
      @state.set endScreen:yes
      # e?.stopPropagation?()
    else if @state.endScreen or @state.helpScreen
      @state.set endScreen:no, helpScreen:no
    else
      @state.set currentPage:@state.getNextPage()

  onPrevPage: =>
    return unless @ready
    if @state.endScreen or @state.helpScreen
      @state.set endScreen:no, helpScreen:no
    else
      @state.set currentPage:@state.getPrevPage()

  onLoad: =>
    @stack.show()
    firstImg= @stack.find('img').get(0)
    @fullImageHeight= firstImg.naturalHeight
    @fullImageWidth= firstImg.naturalWidth
    @imageWidth= firstImg.width
    @imageHeight= firstImg.height
    @stack.find('.screen').hide()
    @showCurrent()
    @elem.css width:@imageWidth
    @stack
      .css(opacity:0)
      .animate(height:@imageHeight, opacity:1)
    @progressWidth= @progressBar.width()
    @ready= yes
    @state.set ready:yes, loaded:yes

  onLoadError: (e)=>
    log.info "ERROR Loading image", e.target
    @state.set loaded:no
    @progressBar.addClass('errors')
    @stack.find('img').remove()
    err= $("<div class='errors'>There were errors loading the images, please refresh your browser!</div>").hide()
    @stack.append(err).show()
    err.slideDown()


  showCurrent: ->
    displayType= if @state.zoomed then 'table-cell' else 'block'
    @stack.find('.screen').get(@current).style.display= displayType;

  hideCurrent: ->
    $(@stack.find('.screen').get(@current)).hide()

  getData: ->
    screens= []
    from= @model.start
    to= @model.start + @screenCountIdx
    for i in [from..to]
      mdl= src:build_url(@model.path, i)
      # log.info "state", mdl
      screens.push mdl
    data= @model
    data.screens= screens
    data.id= @id
    data.tapOrClick= ->
      if env.mobile then "tap" else "click"
    data.isMobile= env.mobile
    data

  onRender: ->
    for ctrlName in require.modules('viewer/controllers/')
      # log.debug "Create controller:", ctrlName
      require(ctrlName).call @, @elem, @state

    # Hook up events!!
    @progressWidth= @progressBar.width()
    @hookupEvents()

  hookupEvents: ()->    
    if env.mobile
      Hammer(@stack.get(0), prevent_default:yes)
        .on('swipeleft', @onNextPage)
        .on('swiperight', @onPrevPage)
        .on('tap', @didTap)
        .on('hold', @toggleHelp)
        .on('pinchout', @triggerfullScreen)
        .on('pinchin', @triggerInline)
        .on('release', @touchComplete)
      Hammer(@restartBtn.get(0), prevent_default:yes)
        .on('tap', @onRestart)
      # Hammer(@zoomBtn.get(0), prevent_default:yes)
      #   .on('tap', @fullScreen)
      # Hammer(@helpBtn.get(0), prevent_default:yes)
      #   .on('tap', @toggleHelp)
      Hammer(@progressBar.get(0), prevent_default:yes)
        .on('tap', @didTapScrubber)
        .on('drag', @didTapScrubber)
    else
      @elem
        .on('click', '.restart', @onRestart)
        .on('click', '.screen', @didTap)
        # .on('click', '.zoom', @fullScreen)
        # .on('click', '.help', @toggleHelp)
        .on('mousedown', '.progress', @startScrubbing)

  onDomActive: ->
    @elem.focus() if @model.autofocus
      


module.exports= Viewer