
console.log "Server Latency Plugin..."

module.exports= (assembot)->
  {log}= assembot

  assembot.on 'create:server', (server, opts={})->
    opts.http ?= {}

    if opts.http.latency? and opts.http.latency.enabled
      log.info "Activating latency simulator"
      maxAge= opts.http.latency.max ? 3000
      tests= []
      
      for test, time of opts.http.latency.rules
        log.info " - compiling latency test", test
        tests.push matcher:(new RegExp test), time:time, prev:0

      server.use (req, res, next)->
        for test in tests
          if test.matcher.test(req.url)
            waitFor= if test.time < 0
                test.prev + (- test.time)
              else
                test.time
            test.prev= waitFor
            if waitFor >= maxAge
              waitFor= maxAge
              test.prev= 0
            log.info "Waiting....", waitFor, req.url
            setTimeout next, waitFor
            return
        next()
