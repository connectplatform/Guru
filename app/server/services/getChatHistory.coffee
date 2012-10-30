stoic = require 'stoic'
{Chat} = stoic.models

module.exports =
  required: ['accountId', 'chatId']
  service: ({accountId, chatId}, done) ->
    Chat(accountId).get(chatId).history.all (err, history) ->
      if err
        config.log.error 'Error recovering history for chat', {error: err, chatId: chatId, history: history}
        done 'could not find chat'
      else
        done null, history
