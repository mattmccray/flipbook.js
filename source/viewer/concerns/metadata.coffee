log= require('util/log').prefix('metadata:')

buildReactor= (elem, state)->
  (key, sel, updater)->
    el= elem.find(sel)
    handler= (v)->
      # log.info 'reactor!', key, sel, v
      updater.call el, v
    state.on "change:#{ key }", handler
    handler(state[key])

module.exports= (elem, state)->
  reactor= buildReactor(elem, state)

  reactor 'copyright', '.copyright', (value)->
    if value? and value isnt ''
      @html(value).attr('title', value).show()
    else
      @hide()
