stoic = require 'stoic'
{Session, Chat} = stoic.models

render = config.require 'services/templates/renderTemplate'

module.exports = ({chatId, sessionId}, done) ->
  Session.accountLookup.get sessionId, (err, accountId) ->
    Chat(accountId).get(chatId).history.all (err, history) ->
      return done err if err?
      done null, render 'chatHistory', history: history
