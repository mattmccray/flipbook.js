log= require('util/log').prefix('plugin:')
scanner= require 'scanner'
validate= require 'viewer/validator'
Viewer= require 'viewer/index'

fb_builder= (options, value)->
  if options is 'scan'
    flipbooks= scanner.run()
    log.info "SCAN!", flipbooks
    for {item, model} in flipbooks
      if validate(model)
        if $(item).data('controller')?
          log.info "Element already has view!"
        else
          view= new Viewer model
          view.appendTo( $(item).empty() )
      else
        log.info "! Invalid model:", validate.errors(), model

  else if typeof options is 'string' and value?
    if options is 'set' and typeof value is 'object'
      $(this).data('controller').set(value)
    else
      $(this).data('controller').set(options, value)

  else if typeof options is 'object'
    # Build new Viewer and append to this element if it exists, or return it
    if validate(options)
      # log.info "building view!", options
      view= new Viewer options
      unless this is window
        # TODO: Need to make sure the flipbook isn't already created on this element!
        view.appendTo( $(this).empty() )
      # return view
      return this
    else
      log.info "! Invalid model:", validate.errors(), options

  else
    throw new Error "Unknown arguments for flipbook"

  this

module.exports=
  install: ->
    $.fn.flipbook= fb_builder
    $.flipbook= fb_builder