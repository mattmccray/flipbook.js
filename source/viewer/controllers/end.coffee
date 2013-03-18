
module.exports= (elem, state)->
  endScreen= elem.find('.the-end')
  state.on 'change:endScreen', (show)=>
    endScreen.toggle(show)
