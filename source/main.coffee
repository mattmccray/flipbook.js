# FlipBook main

env= require 'env'
log= require('util/log').prefix('main:')
ensure= require 'util/ensure'
scanner= require 'scanner'
validate= require 'validator'

Viewer= require 'viewer/controller'

require('theme').activate()

hammertime= ->
  if env.mobile
    log.info "It's hammer time."
    ensure.libs.hammer()
  else
    log.info "Please hammer, dont' hurt 'em."
    null

ensure 'jquery', hammertime, (err)->
  throw err if err?
  $ init

init= ->
  log.level(2) if env.debug
  log.info "FlipBook v#{ env.version }"
  log.info "ENV", env
  log.info "Ready."
  flipbooks= scanner.run()

  for {item, model} in flipbooks
    if validate(model)
      view= new Viewer model:model
      view.appendTo( $(item).empty() )
    else
      log.info "! Invalid model:", validate.errors(), model

  # Focus first book
  $('.flipbook').get(0)?.focus()

if env.debug and env.mobile
  ensure 'firebug', (err)->
    window.onerror= (err)->
      log.info "ERROR!", err