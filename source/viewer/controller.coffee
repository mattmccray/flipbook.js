env= require 'env'
uid= require 'util/uid'
pad= require 'util/number/pad'
log= require('util/log').prefix('controller:')
events= require 'cog/events'
CogView= require 'cog/view'

nextKeys= [39, 32]
prevKeys= [37]

build_url= (pattern, idx)->
  #hack!
  pattern= pattern.replace('####', pad(idx, 4))
  pattern= pattern.replace('###', pad(idx, 3))
  pattern= pattern.replace('##', pad(idx, 2))
  pattern= pattern.replace('#', idx)


class Viewer extends CogView

  className: 'flipbook'

  template: require('./template')

  outlets:
    stack: '.screen-stack'
    nextBtn: '.nextPage'
    prevBtn: '.prevPage'
    progressBar: '.progress'

  initialize: ->
    @screenCount= @model.pages
    @current= 0
    @ready= no
    @active= no
    @atEnd= no
    # Allows for focus and blur events
    @elem.attr 'tabindex', -1
    if env.mobile
      @elem.addClass 'isMobile'
    else
      @elem.addClass 'isDesktop'

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

  didBlur: (e)=>
    @active= no

  didClickProgress: (e)=>
    e?.preventDefault?()
    log.info "Clicked!", e.target
    idx= $(e.target).data('idx')
    log.info "NavigateTo", idx

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

  loadCheck: ->
    if @loadCount is @screenCount
      if @errorCount > 0
        @stack.find('.screen').hide()
        @stack.append("<div class='errors'>There were errors loading the images, please refresh your browser!</div>").show()
        return
      @showCurrent()
      @imageH= height= @stack.show().find('img').height()
      @imageW= @stack.find('img').width()
      @stack.find('.screen').hide()
      @showCurrent()
      @elem.css width:@imageW
      # log.info "resizing to", height
      @stack
        .css(height:height, opacity:0)
        .animate(opacity:1)
      @fixProgressBarSizes()
      @ready= yes
      # @screenCount= @stack.find('.screen').length

  imageDidLoad: (e)=>
    @loadCount += 1
    idx= $(e.target).data('idx')
    @elem.find("span[data-idx=#{ idx }]").removeClass('loading').addClass('loaded')
    @loadCheck()

  imageDidError: (e)=>
    log.info "ERROR Loading image", e.target
    @loadCount += 1
    @errorCount += 1
    $(e.target).removeClass('loading').addClass('error')
    idx= $(e.target).data('idx')
    @elem.find("span[data-idx=#{ idx }]").removeClass('loading').addClass('error').attr('title', "Error loading: #{ e?.target?.src }")
    @loadCheck()

  showCurrent: ->
    $(@stack.find('.screen').get(@current)).show()
    @elem.find("span[data-idx=#{ @current }]").addClass 'current'

  hideCurrent: ->
    $(@stack.find('.screen').get(@current)).hide()
    @elem.find("span[data-idx=#{ @current }]").removeClass 'current'

  getData: ->
    screens= []
    from= @model.startAt
    to= @model.startAt + (@screenCount - 1)
    for i in [from..to]
      mdl= src:build_url(@model.path, i)
      # log.info "ViewModel", mdl
      screens.push mdl
    data= @model
    data.screens= screens
    data.id= @id
    data

  onRender: ->
    @loadCount= 0
    @errorCount= 0
    # Hook up events!!
    @elem
      .find('img')
      .on( 'load', @imageDidLoad )
      .on( 'error', @imageDidError )
      .end()
      .on('focus', @didFocus)
      .on('blur', @didBlur)
    
    if env.mobile
      Hammer(@stack.get(0))
        .on('swipeleft', @nextPage)
        .on('swiperight', @prevPage)
        .on('tap', @didTap)
      Hammer(@nextBtn.get(0))
        .on('tap', @nextPage)
      Hammer(@prevBtn.get(0))
        .on('tap', @prevPage)
    else
      @elem
        .on('click', '.nextPage', @nextPage)
        .on('click', '.prevPage', @prevPage)
        .on('click', '.screen', @didTap)
        .on('click', '.progress span', @didClickProgress)
      $(document).on 'keydown', @onKeyInput

  fixProgressBarSizes: ->
    w= @progressBar.width()
    iw= w / @screenCount
    log.info "Setting progress bar width to", iw
    @progressBar.find('span').width("#{iw}px")

  onDomActive: ->
    if @options.autofocus
      @elem.focus()
    @fixProgressBarSizes()


module.exports= Viewer