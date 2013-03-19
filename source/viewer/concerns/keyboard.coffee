env= require 'env'
log= require('util/log').prefix('keyboard:')

activeViewer= null

keyListener=
  listening: no

  init: ->
    return if env.mobile or @listening
    @listen()

  listen: ->
    return if env.mobile or @listening
    $(document).on 'keydown', @onKeyInput
    @listening= yes

  stopListening: ->
    return if env.mobile or not @listening
    $(document).off 'keydown', @onKeyInput
    @listening= no

  onKeyInput: (e)->
    if activeViewer?
      return activeViewer.state.trigger 'key:input', e

nextKeys= [32, 39, 68, 221]
prevKeys= [37, 65, 219]
zoomKeys= [27]
restartKeys= []

keyMap=
  # -> ] d SPC
  'cmd:page:next': [32, 39, 68, 221]
  # <- [] a
  'cmd:page:prev': [37, 65, 219]
  # r
  'cmd:restart':   [82]
  # ESC
  'cmd:zoom:out':  [27]
  # z
  'cmd:zoom:toggle':   [90]
  # h ?
  'cmd:help:toggle':   [72, 191]

module.exports= (elem, state)->
  keyListener.init()

  handler= (e)->
    return unless state.ready and state.active
    for cmd, keys of keyMap
      if e.which in keys
        state.trigger cmd
        return false
    log.info "Unknown key:", e.which
    null

  state.on 'key:input', handler
  
  state.on 'change:active', (isActive)->
    activeViewer= if isActive then state.controller else null
