async = require 'async'
db = config.require 'load/mongo'

cache = {}

render = config.require 'services/templates/renderTemplate'

module.exports = (request, response) ->
  sessionId = request.cookies.session
  search = request.query

  getChatArchive = config.service 'getChatArchive'

  getChatArchive {sessionId: sessionId, search: search}, (err, archive) ->
    history = for chat in archive
      render 'chatSummary', chat
    history = history.join ''

    response.end "<html>#{history}</html>"
