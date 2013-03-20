log= require('util/log').prefix('sizing:')

module.exports= (elem, state)->
  imageWidth=0
  imageHeight=0
  imageFullWidth=0
  imageFullHeight=0

  stack= elem.find('.screen-stack')

  state.on 'resize', ->
    if elem.is('.zoomed')
      # elem.css width:state.imageWidth
      resizeFullscreenElements()
    else
      # set size...
      resizeRegularElements()

  getDimensions= ->
    # return if imageFullHeight isnt 0
    # log.info 'calcing sizes'
    wasVisible= stack.is(':visible')
    stack.show() unless wasVisible
    # state.trigger 'cmd:current:show'
    firstImg= elem.find('img').get(0)
    state.imageWidth= imageWidth= firstImg.width
    state.imageHeight= imageHeight= firstImg.height
    state.imageFullWidth= imageFullWidth= firstImg.naturalWidth
    state.imageFullHeight= imageFullHeight= firstImg.naturalHeight
    # log.info imageWidth, 'x', imageHeight, ' -- ', imageFullWidth, 'x', imageFullHeight
    stack.hide() unless wasVisible
    # state.trigger 'cmd:current:hide'


  state.on 'sizes:calc', getDimensions

  resizeRegularElements= ->
    elem.css height:''
    if state.animated and not state.ready and state.autofit
      elem.animate width:state.imageWidth
    else
      if state.autofit
        elem.css width:state.imageWidth
      else
        elem.css width:''
    stack.css(height:state.imageHeight) if state.ready
    elem.find('img').css maxWidth:'100%', maxHeight:''


  resizeFullscreenElements= (e)->
    d= $(window)
    h= d.height()
    w= d.width()
    elem.css width:w, height:h
    # elem.css width:''
    h -= elem.find('.pager').outerHeight()
    h -= elem.find('header').outerHeight()
    h -= elem.find('.copyright').outerHeight()
    # h -= 6 # margin
    stack.css height:h
    elem.find('img').css maxWidth:Math.min(w, imageFullWidth), maxHeight:Math.min(h, imageFullHeight)
