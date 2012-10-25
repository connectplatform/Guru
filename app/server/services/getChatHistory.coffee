stoic = require 'stoic'
{Session, Chat} = stoic.models

module.exports = ({chatId, sessionId}, done) ->
  Session.accountLookup.get sessionId, (err, accountId) ->
    Chat(accountId).get(chatId).history.all (err, history) ->
      if err
        config.log.error 'Error recovering history for chat', {error: err, chatId: chatId, history: history}
        done 'could not find chat'
      else
        done null, history
