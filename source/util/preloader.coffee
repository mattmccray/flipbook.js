log= require('./log').prefix('preloader:')

class Preloader
  constructor: (root)->
    @elem= $(root)

  onError: (@errorCallback)-> @
  onProgress: (@progressCallback)-> @
  onLoad: (@loadCallback)-> @

  start: ->
    # log.debug "START!", @elem
    images= @elem.find('img')
    @total= images.length
    @count= 0
    images
      .on('error', @didError)
      .on('load', @didLoad)
    if @total is @count
      @didError(null)
    @

  didLoad: (e)=>
    # log.debug 'didLoad', e
    @count += 1
    percent= Math.floor( (@count / @total) * 100 )    
    # log.debug "PERCENT", @count, @total, "#{percent}%"
    @progressCallback?(percent)
    if @count is @total
      @progressCallback?(100)
      @elem.find('img').off()
      delete @elem
      # log.debug "Calling loadCallback"
      @loadCallback?(e)

  didError: (e)=>
    @progressCallback?(100)
    @elem.find('img').off()
    delete @elem
    # log.debug "Calling errorCallback"
    @errorCallback?(e)


module.exports= (root)->
  new Preloader root