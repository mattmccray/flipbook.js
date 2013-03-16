module.exports= pad= (num, len)->
  str= "#{num}"
  while str.length < len
    str= "0#{str}"
  str
