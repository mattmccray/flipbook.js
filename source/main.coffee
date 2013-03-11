# FlipBook main

log= require('util/log').prefix('main:')
ensure= require 'util/ensure'

require('theme').activate()

ensure 'jquery', (err)->
  throw err if err?

  log.info "jQuery is ready!"
  $ init

init= ->
  log.info "Log level is", log.level()
  log.info "Ready."
  document.body.innerHTML= "Ready."
