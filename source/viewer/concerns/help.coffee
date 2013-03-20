env= require 'env'

module.exports= helpScreenCtrl= (elem, state)->
  helpScreen= elem.find('.help-content')
  closeBtn= helpScreen.find('.close')
  
  state.on 'change:helpScreen', (show)=>
    helpScreen.toggle(show)
    state.contentScreenVisible= show

  toggleHelp= ->
    return if not state.ready or state.endScreen
    state.toggle 'helpScreen'

  state.on 'cmd:help:toggle', toggleHelp

  closeScreen= (e)->
    e.preventDefault()
    e.stopPropagation()
    state.set helpScreen:no
  
  if env.mobile
    Hammer(closeBtn.get(0), prevent_default:true).on 'tap', closeScreen
  else
    closeBtn.on 'click', closeScreen