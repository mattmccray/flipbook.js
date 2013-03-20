###
Based on Route66 - https://github.com/pazguille/route66

Usage:

  Router= require 'router'

  routes= new Router
  routes.path '/page/:id', (id)-> console.log id
  routes.path '/page/:id/:action', (id, action)-> console.log id, action

OR:

  routes= new Router
  routes.path 
    '/page/:id': (id)-> console.log id
    '/page/:id/:action': (id, action)-> console.log id, action

OR:

  routes= new Router
    '/page/:id': (id)-> console.log id
    '/page/:id/:action': (id, action)-> console.log id, action

TODO:

  - Support updating the hash... redirect(path[, triggerMatches])?

###

location= window.location
binder= if window.addEventListener then 'addEventListener' else 'attachEvent'
load= if window.addEventListener then 'load' else 'onload'
supported= window.onpopstate?
updateurl= if supported then 'popstate' else load

class Path
  constructor: -> (@url)->
    @listeners= []
    @toRegExp()

  toRegExp: ->
    @regexp= new RegExp('^' + this.url.replace(/:\w+/g, '([^\\/]+)').replace(/\//g, '\\/') + '$')
    @


 class Router
  
  getHashPath= -> location.hash.split('#!')[1] || location.hash.split('#')[1]

  constructor: (initialPaths)->
    @_collection= {}
    window[bind] updateurl, (=>
      hash= getHashPath()
      if location.pathname is '/' and hash?
        @_match('/')
      else
        @_match(hash)
    ), false

    unless supported
      window[bind] 'onhashchange', (=>
        hash = getHashPath()
        @_match(hash)
      )

    if initialPaths?
      @path initialPaths

  _match: (hash)->
    for key, path of @_collection
      if path?
        params = hash.match(path.regexp)
        if params
          params.splice(0, 1)
          for listener in path.listeners
            listener.apply(listener, params);
    @

  path: (path, listener)->
    if typeof path is 'object' and not listener? 
      for key,value of path
        @_createPath(key, value) if value?
    else
      @_createPath(path, listener)
    @
  
  _createPath: (path, listener)->
    unless @_collection[path]?
      @_collection[path]= new Path(path)
    @_collection[path].listeners.push(listener)

  remove: (path, listener)->
    listeners= @_collection[path]
    for old_listener,i in listeners
      listeners.splice i, 1 if old_listener is listener
    if listeners.length is 0 or not listener?
      delete @_collection[path]
    @

  paths: (path)->
    if path? then @_collection[path] else @_collection

exports = module.exports = Router