async = require 'async'
db = config.require 'load/mongo'

cache = {}

render = config.require 'services/templates/renderTemplate'

module.exports = (request, response) ->
  sessionId = request.cookies.session
  console.log '[printChatArchive]'.yellow, {'request.cookies': request.cookies}
  console.log '[printChatArchive]'.yellow, {sessionId}
  search = request.query
  console.log '[printChatArchive]'.yellow, {search}

  header = "<h2>Chat History</h3>"
  header += render 'table', {rows: (["<strong>#{f}:</strong>", v] for f, v of search)}

  # getChatArchive = config.service 'getChatArchive'
  console.log 'getChatArchive', {getChatArchive}
  console.log '[printChatArchive]'.yellow, 'here'

  # getChatArchive {sessionId, search}, (err, {archive}) ->
  config.services['getChatArchive'] {sessionId, search}, (err, {archive}) ->
    console.log '[printChatArchive]'.yellow, {archive}
    history = for chat in archive
      render 'chatSummary', chat
    console.log '[printChatArchive]'.yellow, 'rendered all!!!'
    history = history.join ''
    console.log '[printChatArchive]'.yellow, {history}

    history = '<h3>No chat records found</h3>' unless history

    response.end "<html>#{header}#{history}</html>"
