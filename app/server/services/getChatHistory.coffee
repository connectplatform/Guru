stoic = require 'stoic'
{Chat} = stoic.models

module.exports =
  required: ['accountId', 'chatId']
  service: ({accountId, chatId}, done) ->
    Chat(accountId).get(chatId).history.all (err, history) ->
      if err
        config.log.error 'Error recovering history for chat',
          error: err
          chatId: chatId
          history: history
        return done 'could not find chat'

      if history.length is 0
        history.push
          timestamp: new Date().getTime()
          type: 'notification'
          message: 'Welcome to live chat! An operator will be with you shortly.'

      done null, history
