log= require('util/log').prefix('validator:')

errors= []


fixupTypes= (o)->
  o.pages= parseInt(o.pages, 10) if typeof o.pages is 'string'
  o.start= if o.start?
      if typeof o.start is 'string'
        parseInt(o.start, 10)
      else
        o.start
    else
      1
  o.progressAllowEmpty= if o.progressAllowEmpty?
      (ae= o.progressAllowEmpty) is true or ae is 'true' or ae is 'yes'
    else
      true
  o.animated = if o.animated? 
      o.animated is true or o.animated is 'true' or o.animated is 'yes'
    else
      true
  o.copyright ?= ""

module.exports= validator= (options, fixup=false)->
  # Validates all the options a present
  # Need to do more, later... but for now this will do.
  errors= []

  errors.push "path is missing" unless options.path?
  errors.push "pages is missing" unless options.pages?

  if errors.length is 0
    fixupTypes(options) if fixup
    true
  else
    false


validator.errors= ->
  errors.join(', ')