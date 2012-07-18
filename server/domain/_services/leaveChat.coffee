module.exports = (res, chatId) ->
  redgoose = require 'redgoose'
  operatorId = unescape(res.cookie('session'))
  {SessionChat} = redgoose.models

  SessionChat.remove operatorId, chatId, (err) ->
    res.send err, chatId