
module.exports= (value) ->
  return true unless value
  return false for key of value
  true
