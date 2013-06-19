async = require 'async'
db = config.require 'load/mongo'
cache = config.require 'load/cache'

module.exports = ({pathParts, url}, response) ->
  [_, websiteId] = pathParts
  cacheLocation = "chatLinkImage/#{websiteId}"

  getAvailableOperators = config.service 'operator/getAvailableOperators'
  getImageUrl = config.service 'getImageUrl'

  handleError = (err) ->
    console.log 'in handleError'.yellow, err
    if err
      config.log.warn "Failed to find chatLinkImage.", {websiteId: websiteId, url: url, error: err}
      response.writeHead 404
      console.log 'about to call response.end() in handleError'
      response.end()
      return true
    else
      console.log 'well, no error'
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
      console.log 'about to call response.end() in respond'
      response.end()

  # need a websiteId to do anything
  handleError 'No websiteId.' if not websiteId or websiteId is 'undefined'

  # check cache
  cached = cache.retrieve cacheLocation
  console.log {cached}
  # if cached?
  if cached
    console.log {cached}
    console.log 'cached!!!!'
    return respond websiteId, cached
    console.log 'SHOULD NEVER GET HERE'.red
  else

    # is anyone online?
    console.log {websiteId}
    getAvailableOperators {websiteId: websiteId}, (err, data) ->
      console.log 'getAvailableOperators'.yellow, {err, data}
      return if handleError err
      {accountId, operators} = data
      isOnline = (operators.length > 0)

      cache.store cacheLocation, isOnline
      return respond websiteId, isOnline
      console.log 'ALSO SHOULD NEVER GET HERE'.red