module.exports = (res) ->
  redgoose = require 'redgoose'
  sendChatsFromIdList = require '../sendChatsFromIdList'

  operatorId = unescape(res.cookie 'session')

  {Operator} = redgoose.models
  Operator.get(operatorId).chats.all (err, rawData)->
    sendChatsFromIdList res, err, rawData