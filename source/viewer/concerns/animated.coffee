
module.exports= (elem, state)->
  state.on 'change:animated', (animated)->
    elem.toggleClass 'animated', animated