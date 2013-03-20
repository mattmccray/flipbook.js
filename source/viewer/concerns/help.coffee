env= require 'env'
log= require('util/log').prefix('helpScreen:')

module.exports= helpScreenCtrl= (elem, state)->
  helpScreen= elem.find('.help-content')
  introBit= helpScreen.find('.intro')
  closeBtn= helpScreen.find('.close')
  
  state.on 'change:helpScreen', (show)=>
    introBit.toggle env.firstRun if show
    if state.animated
      if show
        helpScreen.fadeIn('fast')
      else
        helpScreen.fadeOut('fast', -> introBit.hide())
    else
      helpScreen.toggle show
    state.contentScreenVisible= show

  toggleHelp= ->
    return if not state.ready or state.endScreen
    state.toggle 'helpScreen'

  state.on 'cmd:help:toggle', toggleHelp
  
  state.on 'ready', ->
    if env.firstRun
      setTimeout(->
        state.set helpScreen:on    
        env.firstRun= no
      , 400)
      

  closeScreen= (e)->
    e.preventDefault()
    e.stopPropagation()
    state.set helpScreen:no
  
  if env.mobile
    Hammer(closeBtn.get(0), prevent_default:true).on 'tap', closeScreen
  else
    closeBtn.on 'click', closeScreen