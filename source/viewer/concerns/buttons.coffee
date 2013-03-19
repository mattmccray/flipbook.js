env= require 'env'

buttonController= (elem, state)->
  (sel, opts)->
    btn= elem.find(sel).addClass('disabled').hide()
    evt= opts.action
    act= opts.update
    state.once 'change:ready', ->
      btn.show()
      if act?
        act.call(btn)
      else
        btn.removeClass('disabled')
    for key in (opts.states ? '').split(',')
      state.on "change:#{ key }", -> act.call(btn)
    handler= (e)-> 
      state.trigger evt unless btn.is '.disabled'
    if env.mobile
      Hammer(btn.get(0), prevent_default:yes).on 'tap', handler
    else
      btn.on 'click', handler

module.exports= (elem, state)->

  button= buttonController(elem, state)

  button '.prevPage',
    action: 'cmd:page:prev'
    states: 'currentPage'
    update: ->
      @toggleClass 'disabled', state.isFirstPage()
  
  button '.nextPage',
    action: 'cmd:page:next'
    states: 'currentPage,endScreen'
    update: ->
      @toggleClass 'disabled', (state.isLastPage() and state.endScreen)

  button '.zoom',
    action: 'cmd:zoom:toggle'


  button '.help',
    action: 'cmd:help:toggle'
    states: 'helpScreen,endScreen'
    update: ->
      @toggleClass 'disabled', (state.endScreen)
      @toggleClass 'down', (state.helpScreen)  
