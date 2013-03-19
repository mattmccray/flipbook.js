
module.exports= helpScreenCtrl= (elem, state)->
  helpScreen= elem.find('.help-content')
  
  state.on 'change:helpScreen', (show)=>
    helpScreen.toggle(show)

  toggleHelp= ->
    return if not state.ready or state.endScreen
    state.toggle 'helpScreen'

  state.on 'cmd:help:toggle', toggleHelp