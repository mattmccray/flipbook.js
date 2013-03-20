env= require 'env'
log= require('util/log').prefix('theme:')

require("themes/#{ 'embedded' }").activate() if env.embedded

# setTheme= (o, defaultTheme='light')->
#   try
#     require("themes/#{ o.theme }").activate()
#   catch ex
#     require("themes/#{ defaultTheme }").activate()
#     o.theme= defaultTheme
#   "theme-#{ o.theme }"

module.exports= (elem, state)->
  # elem.addClass setTheme state

  class_name= (theme)->
    "theme-#{theme}"

  set_theme= (value, oldvalue)->
    # log.info "Theme", value, "old", oldvalue
    elem.removeClass class_name(oldvalue) if oldvalue?
    elem.addClass class_name(value ? 'light')

  state.on "change:theme", set_theme
  set_theme(state.theme)
