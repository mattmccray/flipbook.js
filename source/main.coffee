# FlipBook main

env= require 'env'
log= require('util/log').prefix('main:')
ensure= require 'util/ensure'
# cog= require 'cog'
require('theme').activate()
Viewer= require 'viewer/controller'

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
  $('[data-flipbook]').each (i,item)->
    data= $(item).data('flipbook')
    model={}
    for seg in data.split(',')
      [key, value]= seg.split(':')
      model[$.trim(key)]= $.trim(value)    
    (new Viewer model:model).appendTo( $(item) )
  # Focus
  $('.flipbook').get(0)?.focus()

if env.debug and env.mobile
  ensure 'firebug', (err)->
    window.onerror= (err)->
      log.info "ERROR!", err