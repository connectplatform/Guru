# stoic = require 'stoic'
# {Chat} = stoic.models

module.exports =
  required: ['chatId', 'accountId']
  service: ({chatId, accountId}, done) ->

    getImageUrl = config.service 'getImageUrl'

    Chat(accountId).get(chatId).websiteId.get (err, websiteId) ->
      if err or not websiteId
        config.log.error 'Error getting website in getLogoForChat', {error: err, chatId: chatId} if err
        return done err

      getImageUrl {websiteId: websiteId, imageName: 'logo'}, done
