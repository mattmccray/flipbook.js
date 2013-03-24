
console.log "Flipbook!"

isDebug= String(process.argv[2]) is 'serve'

onLoad= (assembot)->
  console.log "Startup! (debug:#{isDebug})"
  #, process.argv

module.exports=
  assembot:
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
    
    targets:
      "public/flipbook.js":
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

      # "public/flipbook.core.js":
      #   source: "./source"
      #   ident: "flipbook"
      #   main: "main"
      #   autoload: true
      #   debug: isDebug
      #   test: false
      #   prune: true
      #   embedded: false
      #   minify: (if isDebug then 0 else 2)
      #   exclude: "test/*"

      # "public/flipbook.core.css":
      #   source: "./source"
      #   stylus:
      #     compress: yes

      # "public/flextest.css":
      #   source: "./source"
      #   stylus:
      #     compress: yes
