
console.log "Flipbook!"

isDebug= String(process.argv[2]) is 'serve'

build_path= if isDebug
    "public/flipbook.js"
  else
    "flipbox.js"

onLoad= (assembot)->
  console.log "Startup! (debug:#{isDebug})"
  #, process.argv

configuration=
  assembot:
    targets: {}
    options: 
      callback: onLoad
      header: "/* FlipBook v{%- package.version -%} */"
      addHeader: yes
      replaceTokens: yes
      plugins: [ 
        "assembot/lib/plugins/increment-version" 
        "assembot/lib/plugins/server-latency"
      ]
      autoincrement:
        enabled: yes
        target: 'package.json'
        segment: 'build' # or major, minor, patch
        when: 'after:write' 
      http:
        log: no
        latency:
          enabled: yes
          max: 1000
          rules:
            ".(jpg|png|jpeg)": 100

configuration.assembot.targets[ build_path ]=
  source: "./source"
  ident: "flipbook"
  main: "start"
  autoload: true
  debug: isDebug
  test: false
  prune: true
  embedded: true
  minify: (if isDebug then 0 else 2)
  exclude: "test/*"

module.exports= configuration