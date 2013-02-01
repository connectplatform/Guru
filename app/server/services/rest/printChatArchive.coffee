async = require 'async'
db = config.require 'load/mongo'

cache = {}

render = config.require 'services/templates/renderTemplate'

module.exports = (request, response) ->
  sessionId = request.cookies.session
  search = request.query

  header = "<h2>Chat History</h3>"
  header += render 'table', {rows: (["<strong>#{f}:</strong>", v] for f, v of search)}

  getChatArchive = config.service 'getChatArchive'

  getChatArchive {sessionId: sessionId, search: search}, (err, {archive}) ->
    history = for chat in archive
      render 'chatSummary', chat
    history = history.join ''

    history = '<h3>No chat records found</h3>' unless history

    response.end "<html>#{header}#{history}</html>"
