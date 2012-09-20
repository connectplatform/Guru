async = require 'async'
db = config.require 'load/mongo'

queryOperatorsOnline = (siteName, cb) ->
  # TODO make this respond to routing rather than just count operators
  if Math.random() > 0.5
    console.log 'setting to online'
    cb null, true
  else
    console.log 'setting to offline'
    cb null, false

updateStatus = (storageLocation, siteName) ->
  queryOperatorsOnline siteName, (err, isOnline) ->
    storageLocation[siteName] = isOnline
    console.log 'status was updated for ', siteName

startUpdates = (storageLocation, siteName) ->
  console.log 'wooooo'
  schedule =  ->
    updateStatus storageLocation, siteName
  setInterval schedule, 3000

module.exports = ({website, args, response}) ->

  sendResponse = ->
    redirectTarget = "https://s3.amazonaws.com/#{config.app.aws.s3.bucket}/#{website}/"
    if @sites[website]
      redirectTarget += 'online'
    else
      redirectTarget += 'offline'

    response.writeHead 307, {
      "Location": redirectTarget
      "Cache-Control": 'no-cache, no-store, max-age=0, must-revalidate'
    }
    console.log 'about to send'
    response.end()

  unless @sites
    @sites = {}
    Website = db.models['Website']
    Website.find {}, (err, websites) ->
      console.log 'found sites: ', websites
      async.forEach websites, (website) ->
        queryOperatorsOnline website.name, (err, isOnline) ->
          @sites[website.name] = isOnline
          startUpdates @sites, website.name
          return sendResponse()
  else
    sendResponse()
