db = config.require 'load/mongo'
{Chat} = db.models

render = config.require 'services/templates/renderTemplate'

module.exports =
  required: ['chatId', 'accountId', 'sessionId']
  service: ({chatId, accountId, sessionId}, done) ->
    Chat.findById chatId, (err, chat) ->
      return done err if err

      html = render 'chatHistory', chat
      done null, {html}
