###
assembot:
  options:
    autoincrement:
      enabled: yes
      target: './package.json'
      segment: 'build' # or major, minor, patch
      when: 'after:write' 
###

semver= require 'semver'
path= require 'path'

console.log "Increment Version Plugin..."

module.exports= (assembot)->
  {log}= assembot
  assembot.on 'done', (options)->
    return if options.incrementBuild is false
    pinfo= require '../package'
    pinfo.version= semver.inc(pinfo.version, 'build') 
                                            # major, minor, patch, or build
    log.info "Incrementing build version to", pinfo.version
    output= JSON.stringify pinfo, null, 2
    outpath= path.resolve __dirname, '..', "package.json"
    output.to outpath
