env= require 'env'

require("themes/#{ 'embedded' }").activate() if env.embedded

setTheme= (o, defaultTheme='light')->
  try
    require("themes/#{ o.theme }").activate()
  catch ex
    require("themes/#{ defaultTheme }").activate()
    o.theme= defaultTheme
  "theme-#{ o.theme }"

module.exports= (elem, state)->
  # elem.addClass setTheme state
  elem.addClass "theme-#{ state.theme ? 'light'}"