log= require('util/log').prefix('scanner:')
lifecycle= require 'lifecycle'
validate= require 'viewer/validator'

Viewer= require 'viewer/index'

scanners= []

module.exports= api=
  define: (handler)-> 
    scanners.push handler
    @

  # return array of object: [{ item:NODE, model:PARSED_OPTIONS }]
  scan: ->
    results=[]
    for scanner in scanners
      for result in scanner()
        results.push result
    results

  build: (flipbooks)->
    for {item, model} in flipbooks
      if validate(model)
        # log.info $(item).data('controller')
        unless $(item).is('.flipbook-container')
          # log.info "Creating view element!"
          view= new Viewer model
          view.appendTo( $(item).empty() )
          $(item).addClass('flipbook-container')
      else
        log.info "! Invalid model:", validate.errors(), model
    @
  
  run: ->
    @build @scan()

# data-flipbook="KEY:OPTION," scanner
api.define ->
  results=[]
  $('[data-flipbook]').each (i,item)->
    data= $(item).data('flipbook')
    model= {}
    for seg in data.split(',')
      parts= seg.split(':')
      key= parts.shift()
      value= parts.join(':')
      model[$.trim(key)]= $.trim(value)
    results.push item:item, model:model
  results


# data-flipbook-*KEY="OPTION" scanner
api.define ->
  results=[]
  hyphenParser= /-([a-z])/g
  $('[data-flipbook-pages]').each (i,item)->
    i= $(item)
    model= {}
    for att in item.attributes
      name= String(att.name ? att.nodeName)
      if name.indexOf('data-flipbook-') is 0
        name = name.replace('data-flipbook-', '')
        safeName = name.replace hyphenParser, (g)-> g[1].toUpperCase()
        # log.info "munged", name, "to", safeName
        model[safeName]= att.value ? att.nodeValue
    # log.info model
    results.push item:item, model:model
  results

# flipbook-*KEY="OPTION" scanner
api.define ->
  results=[]
  hyphenParser= /-([a-z])/g
  $('[flipbook-pages]').each (i,item)->
    i= $(item)
    model= {}
    for att in item.attributes
      name= String(att.name ? att.nodeName)
      if name.indexOf('flipbook-') is 0
        name = name.replace('flipbook-', '')
        safeName = name.replace hyphenParser, (g)-> g[1].toUpperCase()
        # log.info "munged", name, "to", safeName
        model[safeName]= att.value ? att.nodeValue
    # log.info model
    results.push item:item, model:model
  results