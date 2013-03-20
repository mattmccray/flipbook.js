env= require 'env'
log= require('util/log').prefix('progressBar:')
{getX}= require 'util/positions'

module.exports= progressCtrl= (elem, state)->

  progressBar= elem.find('.progress') #.hide()
  locationBar= elem.find('.progress .location').hide()

  updateWidth= ->
    percent= state.getPercentageRead()
    locationBar.width "#{percent}%"
    locationBar.toggleClass 'done', state.isLastPage()
    locationBar.toggleClass 'start', state.isFirstPage()

  state.once 'change:loaded', (isLoaded)->
    locationBar.toggle isLoaded
    updateWidth()

  state.once 'ready', ->
    progressBar.toggle state.showProgress

  state.on 'change:currentPage', (page)->
    if state.isValidPage(page)
      updateWidth()

  didTapScrubber= (e)->
    isDragging= e.type is 'mousemove' or e.type is 'drag'
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
    progressBar
      .find('span')
      .hide()
      .end()
      .on('mousemove', didTapScrubber)
    elem
      .on('mouseleave', stopScrubbing)
      # .removeClass('animated')
    $(document)
      .on('mouseup', stopScrubbing)
    didTapScrubber(e)
  
  stopScrubbing= (e)->
    progressBar
      .find('span')
      .show()
      .end()
      .off('mousemove', didTapScrubber)
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
