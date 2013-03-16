env= require 'env'
uid= require 'util/uid'
pad= require 'util/number/pad'
log= require('util/log').prefix('controller:')
events= require 'cog/events'
preloader= require './preloader'

CogView= require 'cog/view'

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


nextKeys= [39, 32]
prevKeys= [37]

class Viewer extends CogView

  @active= null

  className: 'flipbook'

  template: require('./template')

  outlets:
    stack: '.screen-stack'
    nextBtn: '.nextPage'
    prevBtn: '.prevPage'
    progressBar: '.progress'
    locationBar: '.progress .location'
    loadingBar: '.progress .loading'


  initialize: ->
    @screenCount= @model.pages
    @current= 0
    @ready= no
    @active= no
    @atEnd= no
    # Allows for focus and blur events
    @elem.attr 'tabindex', -1
    @elem.addClass 'inactive'
    if env.mobile
      @elem.addClass 'isMobile'
    else
      @elem.addClass 'isDesktop'
    keyListener.init()

  onKeyInput: (e)=>
    return unless @ready and @active
    if e.which in nextKeys
      @nextPage(e) if not @atEnd
      false
    else if e.which in prevKeys
      @prevPage(e)
      false

  didTap: (e)=>
    return if @atEnd
    e.preventDefault()
    x= e.offsetX ? e.clientX ? e.gesture?.center.pageX
    if x < (@imageW / 2)
      @prevPage()
    else
      @nextPage()
    false

  didFocus: (e)=>
    @active= yes
    @elem.removeClass('inactive').addClass 'active'
    Viewer.active= this

  didBlur: (e)=>
    @active= no
    @elem.removeClass('active').addClass 'inactive'
    Viewer.active= null if Viewer.active is this


  nextPage: (e)=>
    e?.preventDefault?()
    return unless @ready
    if @current is @screenCount - 1
      if @atEnd
        @hideCurrent()
        @current = 0
        @showCurrent()
        @atEnd= no
        @stack.find('.the-end').hide()
      else
        @stack.find('.the-end').show()
        @atEnd= yes
      return 
    @hideCurrent()
    @current += 1
    @showCurrent()

  prevPage: (e)=>
    e?.preventDefault?()
    return unless @ready
    if @atEnd
      @stack.find('.the-end').hide()
      @atEnd= no
      return
    return if @current is 0
    @hideCurrent()
    @current -= 1
    @showCurrent()

  onLoad: =>
    @loadingBar.addClass('done')
    @locationBar.show()
    @showCurrent()
    @imageH= height= @stack.show().find('img').height()
    @imageW= @stack.find('img').width()
    @stack.find('.screen').hide()
    @showCurrent()
    @elem.css width:@imageW
    @stack
      .css(opacity:0)
      .animate(height:height, opacity:1)
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
    $(@stack.find('.screen').get(@current)).show()
    percent= Math.ceil( (@current + 1) / @screenCount * 100 )
    # log.info "%", percent
    @locationBar.width "#{percent}%"
    if percent >= 100
      @locationBar.addClass('done')
    else
      @locationBar.removeClass('done')
    # @elem.find("span[data-idx=#{ @current }]").addClass 'current'

  hideCurrent: ->
    $(@stack.find('.screen').get(@current)).hide()

  getData: ->
    screens= []
    from= @model.start
    to= @model.start + (@screenCount - 1)
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

    # Hook up events!!
    @locationBar.hide()
    @elem
      .on('focus', @didFocus)
      .on('blur', @didBlur)
    
    if env.mobile
      Hammer(@stack.get(0), prevent_default:yes)
        .on('swipeleft', @nextPage)
        .on('swiperight', @prevPage)
        .on('tap', @didTap)
      Hammer(@nextBtn.get(0), prevent_default:yes)
        .on('tap', @nextPage)
      Hammer(@prevBtn.get(0), prevent_default:yes)
        .on('tap', @prevPage)
    else
      @elem
        .on('click', '.nextPage', @nextPage)
        .on('click', '.prevPage', @prevPage)
        .on('click', '.screen', @didTap)

  onDomActive: ->
    if @options.autofocus
      @elem.focus()


module.exports= Viewer