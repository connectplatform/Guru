async = require 'async'
db = config.require 'load/mongo'
operatorsOnline = config.require 'services/operator/operatorsAreOnline'

module.exports = ({pathParts}, response) ->
  [_, websiteId] = pathParts

  handleError = (err) ->
    if err
      config.log.warn "Request for chat link image received for invalid website", {domain: domain}
      response.writeHead 404
      response.end()
      return true
    else
      return false

  # look up account by websiteId
  {Website} = db.models
  Website.findOne {_id: websiteId}, {accountId: true}, (err, website) ->
    return if handleError err

    # is anyone online?
    operatorsOnline {accountId: website.accountId}, (err, isOnline) ->
      status = if isOnline then 'online' else 'offline'

      # determine location of actual image
      redirectTarget = "https://s3.amazonaws.com/#{config.app.aws.s3.bucket}/website/#{websiteId}/#{status}"

      # return result
      response.writeHead 307, {
        "Location": redirectTarget
        "Cache-Control": 'no-cache, no-store, max-age=0, must-revalidate'
      }
      response.end()
