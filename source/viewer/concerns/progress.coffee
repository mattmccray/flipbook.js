env= require 'env'
log= require('util/log').prefix('progressBar:')
{getX}= require 'util/positions'

module.exports= progressCtrl= (elem, state)->

  progressBar= elem.find('.progress')
  progBars= elem.find('.bar').not('.position')
  locationBar= progressBar.find('.location').hide()
  positionBar= progressBar.find('.position')

  updateWidth= ->
    percent= state.getPercentageRead()
    locationBar.width "#{percent}%"
    locationBar.toggleClass 'done', state.isLastPage()
    locationBar.toggleClass 'start', state.isFirstPage()
    positionBar.html("#{ state.currentPage + 1} / #{ state.pages }")

  state.once 'change:loaded', (isLoaded)->
    locationBar.toggle isLoaded
    positionBar.toggle state.showLocation
    updateWidth()

  state.once 'ready', ->
    progBars.toggle state.showProgress
  
  state.on 'change:showProgress', (show)->
    progBars.toggle show
    updateWidth if show

  state.on 'change:showLocation', (show)->
    positionBar.toggle show

  state.on 'change:currentPage', (page)->
    if state.isValidPage(page)
      updateWidth()

  didTapScrubber= (e)->
    isDragging= e.type is 'mousemove' or e.type is 'drag'
    log.info "didTapScrubber", isDragging, e.type
    x= getX(e)
    l= null
    w= progressBar.width()
    p= (x / w) # best to cache progressBar.width 
    pageF= p * (state.pages - 1)
    page= if isDragging
        Math.round pageF
      else
        l= locationBar.width()
        if x < l 
          Math.floor pageF 
        else 
          Math.ceil pageF
    # log.info 'x', x, 'w', w, 'p', p, 'page', page, "(#{ pageF }) l", l
    # page= state.pages - 1 if page >= state.pages
    # page= 0 if page < 0
    # log.info "SCRUBBER AT", x, (page + 1), '/', state.pages
    state.set currentPage:page

  startScrubbing= (e)->
    return unless state.ready
    return unless state.showProgress
    # log.info progressBar.length
    # log.info elem.length
    progressBar
      .on('mousemove', didTapScrubber)
      .find('span')
      .hide()
      # .end()
    elem
      .on('mouseleave', stopScrubbing)
      # .removeClass('animated')
    $(document)
      .on('mouseup', stopScrubbing)
    log.info "Finished binding..."
    didTapScrubber(e)
  
  stopScrubbing= (e)->
    log.info "stopScrubbing", e.type
    progressBar
      .off('mousemove', didTapScrubber)
      .find('span')
      .show()
      # .end()
    elem
      .off('mouseleave', stopScrubbing)
      # .toggleClass('animated', state.animated)
    $(document)
      .off('mouseup', stopScrubbing)

  if env.mobile
      Hammer(progressBar.get(0), prevent_default:yes)
        .on('tap', didTapScrubber)
        .on('drag', didTapScrubber)
    else
      progressBar
        .on('mousedown', startScrubbing)
