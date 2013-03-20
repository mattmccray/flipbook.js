env= require 'env'

module.exports= (elem, state)->
  endScreen= elem.find('.the-end')
  restartBtn= elem.find('.restart')

  doRestart= (e)->
    e?.preventDefault?()
    e?.stopPropagation?()
    state.set currentPage:0, endScreen:no, helpScreen:no

  state.on 'change:endScreen', (show)=>
    endScreen.toggle(show)
    state.contentScreenVisible= show

  state.on 'cmd:restart', doRestart

  if env.mobile
    Hammer(restartBtn.get(0), prevent_default:yes).on 'tap', doRestart
  else
    restartBtn.on 'click', doRestart


