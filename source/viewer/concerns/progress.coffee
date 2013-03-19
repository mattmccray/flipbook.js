env= require 'env'
log= require('util/log').prefix('progressBar:')
{getX}= require 'util/positions'

module.exports= progressCtrl= (elem, state)->

  progressBar= elem.find('.progress') #.hide()
  locationBar= elem.find('.progress .location').hide()

  updateEmptyness= ->
    elem.toggleClass 'allowEmptyProgress', state.progressAllowEmpty

  updateEmptyness()

  updateWidth= ->
    percent= state.getPercentageRead()
    locationBar.width "#{percent}%"
    locationBar.toggleClass 'done', state.isLastPage()
    locationBar.toggleClass 'start', state.isFirstPage()

  state.once 'change:loaded', (isLoaded)->
    locationBar.toggle isLoaded
    updateWidth()

  state.on 'change:currentPage', (page)->
    if state.isValidPage(page)
      updateWidth()

  state.on 'change:progressAllowEmpty', updateEmptyness

  didTapScrubber= (e)->
    x= getX(e)
    p= (x / progressBar.width()) # best to cache progressBar.width 
    page= Math.round p * state.pages
    page= state.pages - 1 if page > state.pages
    page= 0 if page < 0
    # log.info "SCRUBBER AT", x, p, page, '/', @screenCount
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
