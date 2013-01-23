stoic = require 'stoic'
{Chat} = stoic.models

render = config.require 'services/templates/renderTemplate'

module.exports =
  required: ['chatId', 'accountId', 'sessionId']
  service: ({chatId, accountId, sessionId}, done) ->
    Chat(accountId).get(chatId).history.all (err, history) ->
      return done err if err
      html = render 'chatHistory', {history: history}
      done null, {html: html}
