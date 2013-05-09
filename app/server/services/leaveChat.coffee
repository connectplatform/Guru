# stoic = require 'stoic'
# {ChatSession} = stoic.models

module.exports =
  required: ['accountId', 'chatId', 'sessionId']
  service: ({chatId, sessionId, accountId}, done) ->
    ChatSession(accountId).remove sessionId, chatId, (err) ->
      done err
