preloader= require '../preloader'

module.exports= (elem, state)->
  bar= elem.find('.progress .loading').show()
  loading= (percent)->
    bar.width "#{percent}%"
  loaded= (success)->
    bar.toggle(success)
    bar.toggleClass('done', success)
    state.off 'change:loading', loading
  state.on 'change:loading', loading
  state.once 'change:loaded', loaded
  preloader(elem)
    .onError(@onLoadError)
    .onLoad(@onLoad)
    .onProgress((percent)-> state.set 'loading', percent)
    .start()