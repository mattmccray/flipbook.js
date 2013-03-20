log= require('./log').prefix('positions:')

getXNew= (e)->
  offset= $(e.delegateTarget ? e.currentTarget).offset() #.parent().offset()
  if e.gesture?
    e.gesture.center.pageX - offset.left
  else
    e.pageX - offset.left


getXOld= (e)->
  if e.offsetX?
    log.info "offsetX", e.offsetX, e
    e.offsetX
  else 
    offset= $(e.currentTarget).offset() #.parent().offset()
    if e.gesture?
      e.gesture.center.pageX - offset.left
    else
      e.pageX - offset.left

getX= getXNew

module.exports= {getX}