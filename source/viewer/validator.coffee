log= require('util/log').prefix('validator:')

errors= []

bool= (val, defaultVal)->
  unless val?
    defaultVal
  else
    val is 'true' or val is 'yes'
string= (val, defaultVal)->
  unless val?
    defaultVal
  else
    String(val)
integer= (val, defaultVal)->
  unless val?
    defaultVal
  else
    parseInt(val, 10)

boolProp= (o, prop, defaultVal)-> o[prop]= bool o[prop], defaultVal
intProp= (o, prop, defaultVal)-> o[prop]= integer o[prop], defaultVal
strProp= (o, prop, defaultVal)-> o[prop]= string o[prop], defaultVal



fixupTypes= (o)->
  intProp o, 'pages'
  intProp o, 'start', 1
  boolProp o, 'animated', true
  boolProp o, 'autofocus', false
  boolProp o, 'autofit', true
  boolProp o, 'showHelpButton', true
  boolProp o, 'showZoomButton', true
  boolProp o, 'showLocation', true
  boolProp o, 'showProgress', true
  boolProp o, 'zoomDisabled', false
  boolProp o, 'greedyKeys', false
  strProp o, 'copyright', ""
  strProp o, 'author', ""
  strProp o, 'background', ""
  strProp o, 'title', "&nbsp;"
  strProp o, 'loadingErrorMsg', "There was a problem loading the images, please refresh your browser."


module.exports= validator= (options, fixup=false)->
  # Validates all the options a present
  # Need to do more, later... but for now this will do.
  errors= []

  errors.push "path is missing" unless options?.path?
  errors.push "pages is missing" unless options?.pages?

  if errors.length is 0
    fixupTypes(options) if fixup
    true
  else
    false


validator.errors= ->
  errors.join(', ')