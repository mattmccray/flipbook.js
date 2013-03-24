# FlipBook main

env= require 'env'
log= require('util/log').prefix('flipbook:')
ensure= require 'util/ensure'
lifecycle= require 'lifecycle'
scanner= require 'scanner'
plugin= require 'plugin'

Viewer= require 'viewer/index'

hammertime= ->
  if env.mobile
    # log.info "It's hammer time."
    ensure.libs.hammer()
  else
    # log.info "Please hammer, dont' hurt 'em."
    null

ensure 'jquery', hammertime, (err)->
  throw err if err?
  $ init

init= ->
  log.level(2) if env.debug
  log.info "FlipBook v#{ env.version }"
  log.debug "ENV", env

  plugin.install()

  lifecycle.fire 'init'

  scanner.run()

  lifecycle.fire 'ready'

  # for {item, model} in flipbooks
  #   if validate(model)
  #     view= new Viewer model
  #     view.appendTo( $(item).empty() )
  #   else
  #     log.info "! Invalid model:", validate.errors(), model


if env.debug and env.mobile
  ensure 'firebug', (err)->
    window.onerror= (err)->
      log.info "ERROR!", err
