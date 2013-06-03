db = config.require 'load/mongo'
{Chat} = db.models

module.exports =
  required: ['chatId', 'accountId']
  service: ({chatId, accountId}, done) ->

    getImageUrl = config.service 'getImageUrl'

    Chat.findById chatId, (err, chat) ->
      if err or not chat?.websiteId
        config.log.error 'Error getting website in getLogoForChat', {error: err, chatId: chatId} if err
        return done err
        
      getImageUrl {websiteId: chat?.websiteId, imageName: 'logo'}, done
