log= require('util/log').prefix('focus:')

module.exports= (elem, state)->
  state.on 'change:active', (isActive)=>
    @active= isActive # TODO: Remove me!
    elem
      .toggleClass('inactive', (not isActive))
      .toggleClass('active', isActive)    

  elem.on 'focus', -> 
    state.set active:true
  
  elem.on 'blur', ->  
    # log.info state
    # log.info "greedyKeys", state.greedyKeys
    # log.info "zoomed", elem.is '.zoomed'
    unless state.greedyKeys or elem.is '.zoomed'
      state.set active:false 
