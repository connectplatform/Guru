async = require 'async'
db = config.require 'load/mongo'
cache = config.require 'load/cache'

module.exports = ({pathParts, url}, response) ->
  [_, websiteId] = pathParts
  cacheLocation = "chatLinkImage/#{websiteId}"

  getAvailableOperators = config.service 'operator/getAvailableOperators'
  getImageUrl = config.service 'getImageUrl'

  handleError = (err) ->
    if err
      config.log.warn "Failed to find chatLinkImage.", {websiteId: websiteId, url: url, error: err}
      response.writeHead 404
      response.end()
      return true
    else
      return false

  respond = (websiteId, isOnline) ->
    status = if isOnline then 'online' else 'offline'

    # determine location of actual image
    getImageUrl {websiteId: websiteId, imageName: status}, (err, {url}) ->
      return if handleError err

      # return result
      response.writeHead 307, {
        "Location": url
        "Cache-Control": 'no-cache, no-store, max-age=0, must-revalidate'
      }
      response.end()

  # check cache
  cached = cache.retrieve cacheLocation
  if cached?
    respond websiteId, cached

  else

    # is anyone online?
    getAvailableOperators {websiteId: websiteId}, (err, data) ->
      return if handleError err
      {accountId, operators} = data
      isOnline = (operators.length > 0)

      cache.store cacheLocation, isOnline
      respond websiteId, isOnline
