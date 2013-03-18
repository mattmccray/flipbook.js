env= require 'env'


prevBtnCtrl= (elem, state)->
  evt= 'cmd:page:prev'
  btn= elem.find('.prevPage').addClass('disabled').hide()
  updateState= ->
    btn.toggleClass 'disabled', state.isFirstPage()
  state.once 'change:ready', ->
    btn.show()
    updateState()
  state.on 'change:currentPage', -> updateState()
  if env.mobile
    Hammer(btn.get(0), prevent_default:yes)
      .on 'tap', (e)-> state.trigger evt unless btn.is '.disabled'
  else
    btn.on 'click', (e)-> state.trigger evt unless btn.is '.disabled'

nextBtnCtrl= (elem, state)->
  evt= 'cmd:page:next'
  btn= elem.find('.nextPage').addClass('disabled').hide()
  updateState= ->
    btn.toggleClass 'disabled', (state.isLastPage() and state.endScreen)
  state.once 'change:ready', ->
    btn.show()
    updateState()
  state.on 'change:currentPage', -> updateState()
  state.on 'change:endScreen', -> updateState()
  if env.mobile
    Hammer(btn.get(0), prevent_default:yes)
      .on 'tap', (e)-> state.trigger evt unless btn.is '.disabled'
  else
    btn.on 'click', (e)-> state.trigger evt unless btn.is '.disabled'

helpBtnCtrl= (elem, state)->
  evt= 'cmd:help:toggle'
  btn= elem.find('.help').addClass('disabled').hide()
  updateState= ->
    btn.toggleClass 'disabled', (state.endScreen)
  state.once 'change:ready', ->
    btn.show()
    updateState()
  state.on 'change:endScreen', -> updateState()
  if env.mobile
    Hammer(btn.get(0), prevent_default:yes)
      .on 'tap', (e)-> state.trigger evt unless btn.is '.disabled'
  else
    btn.on 'click', (e)-> state.trigger evt unless btn.is '.disabled'

zoomBtnCtrl= (elem, state)->
  evt= 'cmd:zoom:toggle'
  btn= elem.find('.zoom').hide()
  state.once 'change:ready', ->
    btn.show()
  if env.mobile
    Hammer(btn.get(0), prevent_default:yes)
      .on 'tap', (e)-> state.trigger evt unless btn.is '.disabled'
  else
    btn.on 'click', (e)-> state.trigger evt unless btn.is '.disabled'


module.exports= (elem, state)->
  prevBtnCtrl.call @, elem, state
  nextBtnCtrl.call @, elem, state
  helpBtnCtrl.call @, elem, state
  zoomBtnCtrl.call @, elem, state