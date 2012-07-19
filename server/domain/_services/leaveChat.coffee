module.exports = (res, chatId) ->
  redgoose = require 'redgoose'
  operatorId = unescape(res.cookie('session'))
  {ChatSession} = redgoose.models

  ChatSession.remove operatorId, chatId, (err) ->
    res.send err, chatId