log= require('util/log').prefix('zoom:')

module.exports= (elem, state)->
  stack= elem.find('.screen-stack')

  zoomZoomZoom= (zoomed)->
    # log.info "zoom?", zoomed
    return if zoomed and elem.is('.zoomed')
    return if not zoomed and not elem.is('.zoomed')
    state.trigger 'cmd:current:hide'

    if elem.is '.zoomed'
      elem.detach()
      elem.removeClass('zoomed')
      state.controller.containingElem.append(elem) #FIXME
      $(window).off 'resize', sendResize      
      sendResize()

    else
      elem.detach()
      elem.addClass('zoomed')
      newParent= $('body')
      newParent.after(elem)
      $(window).on 'resize', sendResize
      sendResize()

    elem.focus()
    state.trigger 'cmd:current:show'

  sendResize= ->
    state.trigger 'resize'
  
  state.on 'change:zoomed', zoomZoomZoom
