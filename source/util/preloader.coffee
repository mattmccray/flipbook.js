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
    # log.info "total:", @total
    # console.dir images.get(0)
    @count= 0
    @errors= 0

    images.each (i, image)=>
      # log.info "Image", image
      if image.complete or image.readyState? is 'complete'
        # log.info 'completed++'
        @count += 1
        if image.width is 0 and image.height is 0
          # log.info 'errors++'
          @errors += 1

    images
      .on('error', @didError)
      .on('load', @didLoad)
    if @total is @count
      if @errors > 0
        setTimeout (=> @didError(null)), 1
        
      else
        @count -= 1
        setTimeout (=> @didLoad(null)), 1
    @

  didLoad: (e)=>
    # log.debug 'didLoad', e
    @count += 1
    percent= Math.floor( (@count / @total) * 100 )    
    # log.debug "PERCENT", @count, @total, "#{percent}%"
    @progressCallback?(percent)
    if @count >= @total
      @progressCallback?(100)
      @elem.find('img').off()
      delete @elem
      # log.debug "Calling loadCallback"
      @loadCallback?(e)

  didError: (e)=>
    # log.info "--> err!"
    @progressCallback?(100)
    @elem.find('img').off()
    delete @elem
    # log.debug "Calling errorCallback"
    @errorCallback?(e)


module.exports= (root)->
  new Preloader root