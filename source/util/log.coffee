log_level= 1

clog= do ->
  if console?
    (type, args)-> console[type].apply console, args
  else
    -> # Noop

level= (lvl)->
  if lvl?
    log_level= switch lvl
      when -1, 'none',  'n' then -1
      when  0, 'quiet', '1' then 0
      when  1, 'info',  'i' then 1
      when  2, 'debug', 'd' then 2
      else log_level
  log_level

say= ->
  return if log_level < 0
  clog 'log', arguments

info= ->
  return if log_level < 1
  clog 'info', arguments

debug= ->
  return if log_level < 2
  clog 'debug', arguments

error= ->
  newError= new Error
  if newError.stack?
    lines= newError.stack.split "\n"
    console?.error? "Error", lines[2].trim()
  clog 'warn', arguments

toArray= Array::slice

prefix= (msg)->
  level: level
  say: -> 
    return if log_level < 0
    (a= toArray.call(arguments)).unshift(msg)
    say.apply say, a
  info: -> 
    return if log_level < 1
    (a= toArray.call(arguments)).unshift(msg)
    info.apply info, a
  debug: -> 
    return if log_level < 2
    (a= toArray.call(arguments)).unshift(msg)
    debug.apply debug, a
  error: -> 
    (a= toArray.call(arguments)).unshift(msg)
    error.apply error, a

module.exports= {level, info, debug, error, say, prefix}

`
// IE Hack, source:
// http://stackoverflow.com/questions/5538972/console-log-apply-not-working-in-ie9
if (Function.prototype.bind && console && typeof console.log == "object") {
  [
    "log","info","warn","error","assert","dir","clear","profile","profileEnd"
  ].forEach(function (method) {
      console[method] = this.bind(console[method], console);
  }, Function.prototype.call);
}
`
