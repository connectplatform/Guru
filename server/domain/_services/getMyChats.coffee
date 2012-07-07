module.exports = (res) ->
  redgoose = require 'redgoose'
  sendChatsFromIdList = require '../sendChatsFromIdList'

  operatorId = unescape(res.cookie 'session')

  {OperatorChat} = redgoose.models
  OperatorChat.getChatsByOperator operatorId, (err, rawData)->
    sendChatsFromIdList res, err, Object.keys rawData