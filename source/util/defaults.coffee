type= require './type'

module.exports= defaults= (obj)->
  for source in Array::slice.call(arguments, 1)
    if source
      for key,value of source
        unless obj[key]?
          obj[key]= value
        else if type(obj[key]) is 'object'
          obj[key]= defaults {}, obj[key], value
  obj