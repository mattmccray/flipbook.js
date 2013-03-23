win = window ? global ? this
navigator= navigator ? { userAgent: 'non-browser' }

firstRun= do ->
  if win.localStorage?
    val= localStorage.getItem('firstTimeToFlipBook')
    localStorage.setItem('firstTimeToFlipBook', false)
    val isnt false and val isnt 'false'
  else
    # Other storage?
    false

module.exports=
  version: require('version')
  embedded: {%- embedded -%}
  debug: {%- debug -%}
  test: {%- test -%}
  firstRun: firstRun
  mobile: navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry)/)?
  msie: navigator.userAgent.match(/(MSIE)/)?