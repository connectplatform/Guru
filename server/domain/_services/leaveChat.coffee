module.exports = (res, chatId) ->
  redgoose = require 'redgoose'
  operatorId = unescape(res.cookie('session'))
  {OperatorChat} = redgoose.models

  OperatorChat.remove operatorId, chatId, (err) ->
    res.send err, chatId