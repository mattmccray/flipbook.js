log= require('util/log').prefix('validator:')

errors= []


fixupTypes= (o)->
  o.pages= parseInt(o.pages, 10) if typeof o.pages is 'string'
  o.startAt= if o.startAt?
      parseInt(o.startAt, 10) if typeof o.startAt is 'string'
    else
      1


module.exports= validator= (options)->
  # Validates all the options a present
  # Need to do more, later... but for now this will do.
  errors= []

  errors.push "path is missing" unless options.path?
  errors.push "pages is missing" unless options.pages?

  if errors.length is 0
    fixupTypes(options)
    true
  else
    false


validator.errors= ->
  errors.join(', ')