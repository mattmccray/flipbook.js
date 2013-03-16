libs=
  angular: -> angular ? '//ajax.googleapis.com/ajax/libs/angularjs/1.0.4/angular.min.js'
  backbone: -> Backbone ? '//cdnjs.cloudflare.com/ajax/libs/backbone.js/0.9.10/backbone-min.js'
  fastclick: -> FastClick ? '//cdnjs.cloudflare.com/ajax/libs/fastclick/0.6.0/fastclick.min.js'
  firebug: -> FBL ? 'https://getfirebug.com/releases/lite/1.4/firebug-lite.js'
  hammer: -> Hammer ? 'https://raw.github.com/EightMedia/hammer.js/v1.0.3/dist/hammer.min.js'
  jquery: -> jQuery ? '//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js'
  jqueryui: -> jQuery?.Widget ? '//ajax.googleapis.com/ajax/libs/jqueryui/1.10.1/jquery-ui.min.js'
  underscore: -> _ ? '//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js'
  webfont: -> WebFont ? '//ajax.googleapis.com/ajax/libs/webfont/1.1.2/webfont.js'  
  zepto: -> Zepto ? '//cdnjs.cloudflare.com/ajax/libs/zepto/1.0/zepto.min.js'

protocol= if location.protocol is 'file:' then "http:" else ''

load_script= (name, callback)->
  url= name?() ? libs[name]?() ? null
  return callback(null) unless typeof url is 'string'
  script= document.createElement('script')
  script.type= "text/javascript"
  script.defer= true if loader.defer
  script.async= true if loader.async
  script.onload= (e)-> callback(null)
  script.onerror= (e)-> callback(new Error "Could not load external resource: #{ name } from #{ url }")
  script.src= if url[0] is '/' then "#{ protocol }#{ url }" else url
  script.onreadystatechange= ->  # IE support:
    if script.readyState is 'loaded' or script.readyState is 'complete'
      script.onreadystatechange= null
      callback(null)
  document.getElementsByTagName('HTML')[0].appendChild(script) 
  script

loader= (libs...)->
  callback= if typeof libs[-1..][0] is 'function'
    libs.pop()
  else
    (err)-> 
      throw err if err?
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

# Here's a great graphic visualizing the difference:
# http://peter.sh/experiments/asynchronous-and-deferred-javascript-execution-explained/
loader.async= true
loader.defer= false

loader.libs= libs

if module?
  module.exports= loader
else
  @ensure= loader
