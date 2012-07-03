module.exports = (res) ->
  redis = require '../../redis'
  sendChatsFromIdList = require '../sendChatsFromIdList'
  redis.operators.chats unescape(res.cookie 'session'), (err, rawData)-> 
    sendChatsFromIdList res, err, rawData