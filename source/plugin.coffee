log= require('util/log').prefix('plugin:')
scanner= require 'scanner'
validate= require 'viewer/validator'
Viewer= require 'viewer/index'

fb_builder= (options)->
  if options is 'scan'
    # Run scanner
    log.info 'running scanner!'
    return

    # TODO: Need to make sure the flipbooks aren't already created!
    flipbooks= scanner.run()
    for {item, model} in flipbooks
      if validate(model)
        view= new Viewer model:model
        view.appendTo( $(item).empty() )
      else
        log.info "! Invalid model:", validate.errors(), model

  else if typeof options is 'object'
    # Build new Viewer and append to this element if it exists, or return it
    if validate(options)
      log.info "building view!", options
      return
      view= new Viewer options
      unless this is window
        # TODO: Need to make sure the flipbook isn't already created on this element!
        view.appendTo( $(this).empty() )
      return view
    else
      log.info "! Invalid model:", validate.errors(), options

  else
    throw new Error "Unknown arguments for flipbook"

module.exports=
  install: ->
    $.fn.flipbook= fb_builder
    $.flipbook= fb_builder