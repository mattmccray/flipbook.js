log= require './log'

libs=
  jquery: 
    url: '//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js'
    test: -> window.jQuery?
  jqueryui: 
    url: '//ajax.googleapis.com/ajax/libs/jqueryui/1.10.1/jquery-ui.min.js'
    test: -> window.jQuery.Widget? # Will this work?
  webfont: 
    url: '//ajax.googleapis.com/ajax/libs/webfont/1.1.2/webfont.js'
    test: -> window.WebFont?
  angular: 
    url: '//ajax.googleapis.com/ajax/libs/angularjs/1.0.4/angular.min.js'
    test: -> window.angular?
  backbone: 
    url: '//cdnjs.cloudflare.com/ajax/libs/backbone.js/0.9.10/backbone-min.js'
    test: -> window.Backbone?
  underscore: 
    url: '//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js'
    test: -> window._?
  marionette: 
    url: '//cdnjs.cloudflare.com/ajax/libs/backbone.marionette/1.0.0-rc4-bundled/backbone.marionette.min.js'
    test: -> window.Backbone.Marionette?
  zepto: 
    url: '//cdnjs.cloudflare.com/ajax/libs/zepto/1.0/zepto.min.js'
    test: -> window.Zepto?

load_script= (name, callback)->
  protocol= if location.protocol is 'file:' then "http:" else ''
  def= libs[name]
  unless def?
    return callback new Error "Library not found. (#{ name })"
  if def.test()
    return callback(null)
  url= def.url
  script= document.createElement('script')
  script.defer= true if loader.defer
  script.async= true if loader.async
  script.onload= (e)-> callback(null)
  script.onerror= (e)-> callback(new Error "Could not load external resource: #{ name } from #{ url }")
  script.src= "#{ protocol }#{ url }"
  document.getElementsByTagName('HTML')[0].appendChild(script) 
  script

loader= (libs...)->
  log.debug "loading", libs
  log.debug libs[-1..]
  callback= if typeof libs[-1..][0] is 'function'
    libs.pop()
  else
    (err)-> 
      if err?
        throw err
      else
        console?.log? "Library loading complete."
  nextLib= libs.shift()
  load_handler= (err)->
    return callback(err) if err?
    if libs.length is 0
      callback(null)
    else
      nextLib= libs.shift()
      load_script nextLib, load_handler
  load_script nextLib, load_handler
  null

loader.async= true
loader.defer= false

# Here's a great graphic visualizing the difference:
# http://peter.sh/experiments/asynchronous-and-deferred-javascript-execution-explained/

module.exports= loader
