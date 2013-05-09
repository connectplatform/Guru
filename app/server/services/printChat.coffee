# stoic = require 'stoic'
# {Chat} = stoic.models

render = config.require 'services/templates/renderTemplate'

module.exports =
  required: ['chatId', 'accountId', 'sessionId']
  service: ({chatId, accountId, sessionId}, done) ->
    Chat(accountId).get(chatId).dump (err, chatData) ->
      return done err if err

      html = render 'chatHistory', chatData
      done null, {html}
