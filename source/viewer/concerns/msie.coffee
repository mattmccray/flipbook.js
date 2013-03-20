# Fuckin' IE

env= require 'env'
log= require('util/log').prefix('msie:')

module.exports= (elem, state)->
  return unless env.msie
  # log.info "You are on MSIE. I'm sorry."

  elem.attr 'tabindex', '0'

  doFocus= -> elem.focus()

  state.on 'change:currentPage', doFocus
  state.on 'change:helpScreen', doFocus
  state.on 'change:endScreen', doFocus

  # state.on 'change:', doFocus