async = require 'async'
db = config.require 'load/mongo'

cache = {}

render = config.require 'services/templates/renderTemplate'

module.exports = (request, response) ->
  sessionId = request.cookies.session

  getChatArchive = config.service 'getChatArchive'

  getChatArchive {sessionId: sessionId}, (err, archive) ->
    history = for chat in archive
      render 'chatSummary', chat
    history = history.join ''

    response.end history

  #handleError = (err) ->
    #if err
      #config.log.warn "Request for chat link image received for invalid website", {domain: domain}
      #response.writeHead 404
      #response.end()
      #return true
    #else
      #return false

  #respond = (isOnline) ->
    #status = if isOnline then 'online' else 'offline'

    ## determine location of actual image
    #redirectTarget = "https://s3.amazonaws.com/#{config.app.aws.s3.bucket}/website/#{websiteId}/#{status}"

    ## return result
    #response.writeHead 307, {
      #"Location": redirectTarget
      #"Cache-Control": 'no-cache, no-store, max-age=0, must-revalidate'
    #}
    #response.end()

  #getChatArchive {}, (err, {accountId, operators}) ->
    #return if handleError err
    #isOnline = (operators.length > 0)
    #cache[websiteId] = [isOnline, Date.now()]
    #respond isOnline
