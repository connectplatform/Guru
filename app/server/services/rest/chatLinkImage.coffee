async = require 'async'
db = config.require 'load/mongo'
stoic = require 'stoic'

queryOperatorsOnline = (siteName, cb) ->
  # TODO
  console.log 'pretend this does something'
  cb null, true

updateStatus = (storageLocation, siteName) ->
  queryOperatorsOnline siteName, (err, isOnline) ->
    storageLocation[siteName] = isOnline
    console.log 'status was updated for ', siteName

startUpdates = (storageLocation, siteName) ->
  console.log 'wooooo'
  schedule =  ->
    updateStatus storageLocation, siteName
  setInterval schedule, 10000

module.exports = ({website, args, response}) ->

  sendResponse = ->
    redirectTarget = "https://s3.amazonaws.com/#{config.app.aws.s3.bucket}/#{website}/"
    if @sites[website]
      redirectTarget += 'online'
    else
      redirectTarget += 'offline'

    response.writeHead 307, {
      "Location": redirectTarget
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
