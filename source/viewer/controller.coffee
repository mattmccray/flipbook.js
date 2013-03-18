env= require 'env'
uid= require 'util/uid'
pad= require 'util/number/pad'
log= require('util/log').prefix('controller:')
events= require 'cog/events'
preloader= require './preloader'

require('./layout').activate()

CogView= require 'cog/view'

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

nextKeys= [32, 39, 68, 221]
prevKeys= [37, 65, 219]

class Viewer extends CogView

  @active= null

  className: 'flipbook'

  template: require('./template')

  outlets:
    stack: '.screen-stack'
    nextBtn: '.nextPage'
    prevBtn: '.prevPage'
    zoomBtn: '.zoom'
    restartBtn: '.restart'
    pagerArea: '.pager'
    progressBar: '.progress'
    locationBar: '.progress .location'
    loadingBar: '.progress .loading'


  initialize: ->
    @screenCount= @model.pages
    @screenCountIdx= @screenCount - 1
    @current= 0
    @ready= no
    @active= no
    @atEnd= no
    # Allows for focus and blur events
    @elem
      .attr('tabindex', -1)
      .addClass('inactive')
      .addClass setTheme(@model)
    if env.mobile
      @elem.addClass 'isMobile'
    else
      @elem.addClass 'isDesktop'
    keyListener.init()

  fullScreen: (e)=>
    return unless @ready
    e?.preventDefault()
    @hideCurrent()
    if @elem.is '.zoomed'
      @elem.remove()
      @elem.removeClass('zoomed')
      @containingElem.append(@elem)
      @elem.css width:@imageWidth, height:''
      @stack.css(height:@imageHeight)
      @progressWidth= @progressBar.width()
      $(window).off 'resize', @resizeFullscreenElements
      @stack.find('img').css maxWidth:'100%', maxHeight:''
    else
      @elem.remove()
      @elem.addClass('zoomed')
      newParent= $('body')
      newParent.after(@elem)
      @resizeFullscreenElements()
      @resizeFullscreenElements()
      $(window).on 'resize', @resizeFullscreenElements
    @showCurrent()
    @hookupEvents()
  
  resizeFullscreenElements: (e)=>
    d= $(window)
    h= d.height()
    w= d.width()
    @elem.css width:w, height:h
    h -= @elem.find('.pager').outerHeight()
    h -= @elem.find('header').outerHeight()
    h -= @elem.find('.copyright').outerHeight()
    @stack.css height:h
    log.info "Setting maxHeight", h, @fullImageHeight
    @stack.find('img').css maxWidth:Math.min(w, @fullImageWidth), maxHeight:Math.min(h, @fullImageHeight)
    @progressWidth= @progressBar.width()


  triggerfullScreen: =>
    @goFullscreen= yes unless @elem.is('.zoomed')
  triggerInline: =>
    @goInline= yes if @elem.is('.zoomed')

  touchComplete: (e)=>
    if @goFullscreen
      @fullScreen(e)
      @goFullscreen= no
      @goInline= no
    else if @goInline
      @fullScreen(e)
      @goFullscreen= no
      @goInline= no

  onKeyInput: (e)=>
    return unless @ready and @active
    if e.which in nextKeys
      @nextPage(e) if not @atEnd
      false
    else if e.which in prevKeys
      @prevPage(e)
      false
    else if e.which is 27
      if @elem.is '.zoomed'
        @fullScreen()

  navigateTo: (idx)=>
    return if not @ready or idx is @current or idx < 0 or idx is @screenCount
    if @atEnd
      @stack.find('.the-end').hide()
      @atEnd= no
      @nextBtn.toggleClass('disabled', (@atEnd)) 
    @hideCurrent()
    @current = idx
    @showCurrent()

  didTap: (e)=>
    return if @atEnd
    e?.preventDefault?()
    e?.stopPropagation?()
    x= getX(e)
    if x < (@imageWidth / 2)
      @prevPage()
    else
      @nextPage()
    false

  didTapScrubber: (e)=>
    e?.preventDefault?()
    # e?.stopPropagation?()
    x= getX(e)
    p= (x / @progressWidth)
    page= Math.floor p * @screenCount
    page= @screenCount - 1 if page > @screenCount
    page= 0 if page < 0
    # log.info "SCRUBBER AT", x, p, page, '/', @screenCount
    @navigateTo page

  startScrubbing: (e)=>
    return unless @ready
    @elem.focus()
    @progressBar.find('span').hide()
    @progressBar
      .on('mousemove', @didTapScrubber)
    @elem
      .on('mouseleave', @stopScrubbing)
    $(document)
      .on('mouseup', @stopScrubbing)
    @didTapScrubber(e)
  
  stopScrubbing: (e)=>
    @progressBar.find('span').show()
    @progressBar
      .off('mousemove', @didTapScrubber)
    @elem
      .off('mouseleave', @stopScrubbing)
    $(document)
      .off('mouseup', @stopScrubbing)

  didFocus: (e)=>
    @active= yes
    @elem.removeClass('inactive').addClass 'active'
    Viewer.active= this

  didBlur: (e)=>
    return if @elem.is '.zoomed'
    @active= no
    @elem.removeClass('active').addClass 'inactive'
    Viewer.active= null if Viewer.active is this

  nextPage: (e)=>
    e?.preventDefault?()
    return unless @ready
    if $(e?.currentTarget).is('.nextPage')
      return if @atEnd
    if @current is @screenCountIdx
      if @atEnd
        @hideCurrent()
        @current= 0
        @atEnd= no
        @stack.find('.the-end').hide()
        @showCurrent()
      else
        @stack.find('.the-end').show()
        @atEnd= yes
        @nextBtn.toggleClass('disabled', (@atEnd)) 
      e?.stopPropagation?()
      return false
    @hideCurrent()
    @current += 1
    @showCurrent()

  prevPage: (e)=>
    e?.preventDefault?()
    return unless @ready
    if @atEnd
      @stack.find('.the-end').hide()
      @atEnd= no
      @nextBtn.toggleClass('disabled', (@atEnd)) 
      return
    return if @current is 0
    @hideCurrent()
    @current -= 1
    @showCurrent()

  onLoad: =>
    @zoomBtn.removeClass 'disabled'
    @nextBtn.removeClass('disabled')
    @loadingBar.addClass('done')
    @locationBar.show()
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

  onLoadError: (e)=>
    log.info "ERROR Loading image", e.target
    @progressBar.addClass('errors')
    @loadingBar.hide()
    @stack.find('img').remove()
    err= $("<div class='errors'>There were errors loading the images, please refresh your browser!</div>").hide()
    @stack.append(err).show()
    err.slideDown()

  showCurrent: ->
    if @elem.is('.zoomed')
      $(@stack.find('.screen').get(@current)).css(display:'table-cell')
    else
      $(@stack.find('.screen').get(@current)).show()
    percent= if (@current is @screenCountIdx)
      100
    else
      Math.min Math.ceil( ((@current + 1) / @screenCount) * 100 ), 100
    # log.info "%", percent, @current
    @locationBar.width "#{percent}%"
    # @locationBar.toggle((@current is 0))
    @locationBar.toggleClass 'done', (@current is @screenCountIdx)
    @prevBtn.toggleClass('disabled', (@current is 0)) 
    @nextBtn.toggleClass('disabled', (@atEnd)) 


  hideCurrent: ->
    $(@stack.find('.screen').get(@current)).hide()

  getData: ->
    screens= []
    from= @model.start
    to= @model.start + @screenCountIdx
    for i in [from..to]
      mdl= src:build_url(@model.path, i)
      # log.info "ViewModel", mdl
      screens.push mdl
    data= @model
    data.screens= screens
    data.id= @id
    data

  onRender: ->
    preloader(@elem)
      .onError(@onLoadError)
      .onLoad(@onLoad)
      .onProgress((percent)=> 
        @loadingBar.width "#{percent}%"
        @loadingBar.addClass('done') if percent >= 100
        )
      .start()
    @nextBtn.addClass('disabled')
    @prevBtn.addClass('disabled')
    @zoomBtn.addClass('disabled')
    # Hook up events!!
    @locationBar.hide()
    @progressWidth= @progressBar.width()
    @hookupEvents()

  hookupEvents: (reassign=false)=>
    @elem
      .on('focus', @didFocus)
      .on('blur', @didBlur)
    
    if env.mobile and not reassign
      Hammer(@stack.get(0), prevent_default:yes)
        .on('swipeleft', @nextPage)
        .on('swiperight', @prevPage)
        .on('tap', @didTap)
        .on('pinchout', @triggerfullScreen)
        .on('pinchin', @triggerInline)
        .on('release', @touchComplete)
      Hammer(@nextBtn.get(0), prevent_default:yes)
        .on('tap', @nextPage)
      Hammer(@prevBtn.get(0), prevent_default:yes)
        .on('tap', @prevPage)
      Hammer(@restartBtn.get(0), prevent_default:yes)
        .on('tap', @nextPage)
      Hammer(@zoomBtn.get(0), prevent_default:yes)
        .on('tap', @fullScreen)
      Hammer(@progressBar.get(0), prevent_default:yes)
        .on('tap', @didTapScrubber)
        .on('drag', @didTapScrubber)
    else
      @elem
        .on('click', '.nextPage', @nextPage)
        .on('click', '.restart', @nextPage)
        .on('click', '.prevPage', @prevPage)
        .on('click', '.screen', @didTap)
        .on('click', '.zoom', @fullScreen)
        .on('mousedown', '.progress', @startScrubbing)



  onDomActive: ->
    if @model.autofocus
      @elem.focus()
      # @didFocus()


module.exports= Viewer