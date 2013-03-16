module.exports= (obj)->
  for source in Array::slice.call(arguments, 1)
    if source
      for key,value of source
        obj[key]= value
  obj
