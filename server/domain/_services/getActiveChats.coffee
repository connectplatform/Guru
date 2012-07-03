module.exports = (res) ->
  redis = require '../../redis'
  sendChatsFromIdList = require '../sendChatsFromIdList'
  redis.chats.getChatIds (err, rawData)->
    sendChatsFromIdList res, err, rawData