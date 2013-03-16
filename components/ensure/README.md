# Ensure

Takes the simplest approach to ensure a page has the libraries you need, or loads 'em from a CDN. Good for use in components, or embedded scripts.

```javascript
ensure('jquery', function(err){
  if(err) throw err;

  // jQuery is ready, do something with it.
})
```

```javascript
ensure('jquery', 'underscore', 'backbone', function(err){
  if(err) throw err;

  // It's all loaded, go for it!
})
```

Comes with support for:

- AngularJS
- Backbone
- Hammer
- jQuery
- jQuery UI
- Underscore
- WebFont
- Zepto

For libraries not built in, just pass in a function that returns a url string if the script needs to be loaded. (shown in coffeescript)

```coffeescript
blam= -> blam ? "//darthapo.github.com/blam.js/blam.min.js"

ensure 'jquery', blam, (err)->
  throw err if err?
```



