
module.exports= (elem, state)->
  state.on 'change:active', (isActive)=>
    @active= isActive # TODO: Remove me!
    elem
      .toggleClass('inactive', (not isActive))
      .toggleClass('active', isActive)    

  elem.on 'focus', -> state.set active:true
  elem.on 'blur', ->  state.set active:false unless elem.is '.zoomed'
