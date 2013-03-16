uid= require 'util/uid'
log= require('util/log').prefix('controller:')
events= require 'cog/events'
CogView= require 'cog/view'

nextKeys= [39, 32]
prevKeys= [37]

class Viewer extends CogView

  className: 'flipbook'

  template: require('./template')

  events:
    'click .nextPage': 'nextPage'
    'click .prevPage': 'prevPage'
    'focus': 'didFocus'
    'blur': 'didBlur'

  outlets:
    stack: '.screen-stack'

  initialize: ->
    @screenCount= parseInt(@model.pages)
    @current= 0
    @ready= no
    @active= no
    @atEnd= no
    # Allows for focus and blur events
    @elem.attr 'tabindex', -1

  onKeyInput: (e)=>
    return unless @ready and @active
    if e.which in nextKeys
      @nextPage(e) if not @atEnd
      false
    else if e.which in prevKeys
      @prevPage(e)
      false

  onDomActive: ->
    if @options.autofocus
      @elem.focus()

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

  nextPage: (e)=>
    e?.preventDefault?()
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
      @ready= yes
      # @screenCount= @stack.find('.screen').length

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
    if Hammer?
      Hammer(@elem.get(0))
        .on('swipeleft', @nextPage)
        .on('swiperight', @prevPage)
        .on('tap', @didTap)
    else
      @elem.on 'click', '.screen', @didTap



module.exports= Viewer