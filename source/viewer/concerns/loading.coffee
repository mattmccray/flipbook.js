log= require('util/log').prefix 'loading:'
preloader= require 'util/preloader'

module.exports= (elem, state)->
  bar= elem.find('.progress .loading').show()

  loading= (percent)->
    bar.width "#{percent}%"

  loaded= (success)->
    bar.toggle(success)
    bar.toggleClass('done')
    state.off 'change:loading', loading

  state.on 'change:loading', loading
  state.once 'change:loaded', loaded
  
  preload_error= ->
    state.set loaded:no
    state.trigger 'load:error'

  preload_loaded= ->
    state.set loaded:yes
    state.trigger 'load:complete'

  preload_progress= (percent)-> 
    state.set 'loading', percent

  # log.info "creating preloader"
  preloader(elem)
    .onError( preload_error )
    .onLoad( preload_loaded)
    .onProgress( preload_progress )
    .start()