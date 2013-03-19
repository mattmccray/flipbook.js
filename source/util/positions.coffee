
getX= (e)->
  if e.offsetX?
    e.offsetX
  else 
    offset= $(e.currentTarget).offset() #.parent().offset()
    if e.gesture?
      e.gesture.center.pageX - offset.left
    else
      e.pageX - offset.left

module.exports= {getX}