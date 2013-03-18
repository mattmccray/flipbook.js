module.exports= progressCtrl= (elem, state)->
  progressBar= elem.find('.progress .location').hide()
  updateWidth= ->
    percent= state.getPercentageRead()
    progressBar.width "#{percent}%"
    progressBar.toggleClass 'done', state.isLastPage()
  state.once 'change:loaded', (isLoaded)->
    progressBar.toggle isLoaded
    updateWidth()
  state.on 'change:currentPage', (page)->
    if state.isValidPage(page)
      updateWidth()
