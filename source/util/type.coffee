
module.exports= do ->
  toStr= Object::toString
  elemParser= /\[object HTML(.*)\]/
  classToType= {}
  for name in "Boolean Number String Function Array Date RegExp Undefined Null NodeList".split(" ")
    classToType["[object " + name + "]"] = name.toLowerCase()
  (obj) ->
    strType= toStr.call(obj)
    if found= classToType[strType]
      found
    else if found= strType.match(elemParser)
      found[1].toLowerCase()
    else
      "object"