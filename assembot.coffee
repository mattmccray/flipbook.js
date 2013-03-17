
console.log "Assembot.coffee!"

onLoad= (assembot)->
  console.log "Startup!"


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
          enabled: no
          max: 1000
          rules:
            ".(jpg|png|jpeg)": -100
    
    targets:
      "public/flipbook.js":
        source: "./source"
        ident: "flipbook"
        main: "main"
        autoload: true
        debug: true
        test: false
        prune: true
        minify: 0
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
