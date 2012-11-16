async = require 'async'
db = config.require 'load/mongo'
getAvailableOperators = config.require 'services/operator/getAvailableOperators'

cache = {}

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

  respond = (isOnline) ->
    status = if isOnline then 'online' else 'offline'

    # determine location of actual image
    redirectTarget = "https://s3.amazonaws.com/#{config.app.aws.s3.bucket}/website/#{websiteId}/#{status}"

    # return result
    response.writeHead 307, {
      "Location": redirectTarget
      "Cache-Control": 'no-cache, no-store, max-age=0, must-revalidate'
    }
    response.end()

  # check cache
  # To generalize caching we could support something like this:
  #   cache.set 'onlineStatus', websiteId, online
  #   cache.get 'onlineStatus', websiteId

  if cache[websiteId]? and (cache[websiteId][1] + 10000) > Date.now()
    respond cache[websiteId][0]

  else

    # is anyone online?
    getAvailableOperators websiteId, null, (err, accountId, operators) ->
      return if handleError err
      isOnline = (operators.length > 0)
      cache[websiteId] = [isOnline, Date.now()]
      respond isOnline
