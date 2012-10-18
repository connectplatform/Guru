async = require 'async'
db = config.require 'load/mongo'
operatorsOnline = config.require 'services/operator/operatorsAreOnline'

updateStatus = (cache, siteName, cb) ->
  #TODO: make this take a site name
  if Date.now() - cache[siteName].timestamp > 10000
    operatorsOnline (isOnline) ->
      cache[siteName].online = isOnline
      cb()
  else
    cb()

module.exports = ({website, args, response}) ->

  sendResponse = ->
    updateStatus @cache, website, ->
      redirectTarget = "https://s3.amazonaws.com/#{config.app.aws.s3.bucket}/#{website}/"
      if @cache[website].online
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
        @cache[site.name] =
          timestamp: 0
          online: false
        updateStatus @cache, site.name, cb
      async.forEach websites, initSite, sendResponse

  else
    sendResponse()
