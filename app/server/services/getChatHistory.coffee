db = config.require 'load/mongo'
{Chat} = db.models

module.exports =
  required: ['sessionSecret', 'chatId']
  service: ({chatId}, done) ->
    Chat.findById chatId, (err, chat) ->
      if err or not chat?
        config.log.error 'Error recovering history for chat',
          error: err
          chatId: chatId
          history: chat?.history
        return done 'could not find chat'
      # HERE BE DRAGONS
      if chat.history.length is 0
        chat.history.push
          timestamp: new Date().getTime()
          type: 'notification'
          message: 'Welcome to live chat! An operator will be with you shortly.'
      done err, {history: chat.history}
