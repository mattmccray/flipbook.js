env= require 'env'

module.exports= (elem, state)->
  endScreen= elem.find('.the-end')
  restartBtn= endScreen.find('.restart')
  closeBtn= endScreen.find('.close')

  doRestart= (e)->
    e?.preventDefault?()
    e?.stopPropagation?()
    state.set currentPage:0, endScreen:no, helpScreen:no

  state.on 'change:endScreen', (show)=>
    if state.animated
      if show
        endScreen.fadeIn('fast')
      else
        endScreen.fadeOut('fast')
    else
      endScreen.toggle(show)
    state.contentScreenVisible= show

  state.on 'cmd:restart', doRestart

  if env.mobile
    Hammer(restartBtn.get(0), prevent_default:yes).on 'tap', doRestart
  else
    restartBtn.on 'click', doRestart

  closeScreen= (e)->
    e.preventDefault()
    e.stopPropagation()
    state.set endScreen:no
  
  if env.mobile
    Hammer(closeBtn.get(0), prevent_default:true).on 'tap', closeScreen
  else
    closeBtn.on 'click', closeScreen