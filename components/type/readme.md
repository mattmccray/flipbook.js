# type

Simple js component that is an enhanced typeof function. Reliably returns object types, and element types for modern browsers.

```javascript
type(null)
// => "null"
type(window.undefinedProperty)
// => "undefined"
type("test")
// => "string"
type(new String)
// => "string"
type(1)
// => "number"
type(new Number)
// => "number"
type(true)
// => "boolean"
type(new Boolean)
// => "boolean"
type(/test/)
// => "regexp"
type(new RegExp)
// => "regexp"
type(new Date)
// => "date"
type(['test'])
// => "array"
type(new Array)
// => "array"
type({'test':'test'})
// => "object"
type(new Object)
// => "object"
type(document)
// => "document"
type(document.querySelectorAll('*'))
// => "nodelist"
type(document.body)
// => "bodyelement"
type(document.createElement('div'))
// => "divelement"
```