
setTheme= (o, defaultTheme='light')->
  try
    require("themes/#{ o.theme }").activate()
  catch ex
    require("themes/#{ defaultTheme }").activate()
    o.theme= defaultTheme
  "theme-#{ o.theme }"

module.exports= (elem, state)->
  elem.addClass setTheme state
