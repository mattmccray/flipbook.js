module.exports=
  version: require('version')
  debug: {%- embedded -%}
  debug: {%- debug -%}
  test: {%- test -%}
  mobile: navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry)/)?