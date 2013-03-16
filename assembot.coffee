
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
      plugins: [ "./lib/increment-version" ]
    
    targets:
      "public/flipbook.js":
        source: "./source"
        ident: "flipbook"
        main: "main"
        autoload: true
        debug: true
        test: false
        prune: true
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
