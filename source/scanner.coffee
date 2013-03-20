log= require('util/log').prefix('scanner:')
lifecycle= require 'lifecycle'

scanners= []

module.exports= api=
  define: (handler)-> 
    scanners.push handler
    @
  # return array of object: [{ item:NODE, model:PARSED_OPTIONS }]
  run: ->
    results=[]
    for scanner in scanners
      for result in scanner()
        results.push result
    results

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