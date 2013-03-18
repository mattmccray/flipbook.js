
module.exports= helpScreenCtrl= (elem, state)->
  helpScreen= elem.find('.help-content')
  state.on 'change:helpScreen', (show)=>
    helpScreen.toggle(show)
