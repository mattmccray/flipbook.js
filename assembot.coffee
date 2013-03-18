
console.log "Assembot.coffee!"

isDebug= String(process.argv[1]).indexOf('serve') > 0

onLoad= (assembot)->
  console.log "Startup! (debug)", isDebug
  #, process.argv

module.exports=
  assembot:
    options:
      callback: onLoad
      header: "/* FlipBook v{%- package.version -%} */"
      addHeader: yes
      replaceTokens: yes
      plugins: [ 
        "./lib/increment-version" 
        "./lib/server-latency"
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
            ".(jpg|png|jpeg)": -100
    
    targets:
      "public/flipbook.js":
        source: "./source"
        ident: "flipbook"
        main: "main"
        autoload: true
        debug: isDebug
        test: false
        prune: true
        minify: (if isDebug then 0 else 2)
        exclude: "test/*"

      # "flipbook.js": 
      #   source: "./source"
      #   ident: "flipbook"
      #   main: "main"
      #   autoload: true
      #   debug: false
      #   test: false
      #   prune: true
      #   minify: 2
      #   exclude: "test/*"

      # "test/flipbook.debug.js": 
      #   source: "./source"
      #   ident: "flipbook"
      #   autoload: true
      #   debug: true
      #   test: true
      #   main: "test/main"
