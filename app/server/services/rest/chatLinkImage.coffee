async = require 'async'
db = config.require 'load/mongo'
operatorsOnline = config.require 'services/operator/operatorsAreOnline'

updateStatus = (cache, domain, cb) ->
  if Date.now() - cache[domain].timestamp > 10000
    operatorsOnline domain, (err, isOnline) ->
      cache[domain].online = isOnline
      cb()
  else
    cb()

module.exports = ({domain, args, response}) ->

  sendResponse = ->
    redirectTarget = "https://s3.amazonaws.com/#{config.app.aws.s3.bucket}/#{domain}/"
    unless @cache[domain]
      return config.log.warn "Request for chat link image received for invalid website domain", {domain: domain}
    updateStatus @cache, domain, ->
      if @cache[domain].online
        redirectTarget += 'online'
      else
        redirectTarget += 'offline'

      response.writeHead 307, {
        "Location": redirectTarget
        "Cache-Control": 'no-cache, no-store, max-age=0, must-revalidate'
      }
      response.end()

  unless @cache
    @cache = {}
    {Website} = db.models
    Website.find {}, (err, websites) ->
      initSite = (site, cb) ->
        @cache[site.url] =
          timestamp: 0
          online: false
        updateStatus @cache, site.url, cb
      async.forEach websites, initSite, sendResponse

  else
    sendResponse()
