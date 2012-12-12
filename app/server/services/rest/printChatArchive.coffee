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

    response.end "<html>#{history}</html>"
