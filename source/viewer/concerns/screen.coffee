env= require 'env'
log= require('util/log').prefix 'screen:'
{getX}= require 'util/positions'

module.exports= (elem, state)->
  stack= elem.find('.screen-stack') #.hide()
  pending= null

  state.on 'change:loaded', (loaded)->
    # log.info 'stack loaded?', loaded
    stack.toggle loaded

  didTap= (e)->
    return if state.endScreen or state.helpScreen or not state.ready
    tgt= $(e.currentTarget)
    e?.preventDefault?()
    # e?.stopPropagation?()
    if getX(e) < (tgt.width() / 2)
      state.trigger 'cmd:page:prev'
    else
      state.trigger 'cmd:page:next'
    false

  touchComplete= (e)->
    if pending?
      state.trigger pending
      pending= null

  trigger= (cmd)->
    -> state.trigger cmd
  deferred= (cmd)->
    -> pending= cmd

  if env.mobile
    Hammer(stack.get(0), prevent_default:yes)
      .on('swipeleft', trigger 'cmd:page:next')
      .on('swiperight', trigger 'cmd:page:prev')
      .on('tap', didTap)
      .on('hold', trigger 'cmd:help:toggle')
      .on('pinchout', deferred 'cmd:zoom:in')
      .on('pinchin', deferred 'cmd:zoom:out')
      .on('release', touchComplete)
  else
    stack
      .on('click', didTap)
