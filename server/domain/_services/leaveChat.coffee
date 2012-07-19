redgoose = require 'redgoose'
{ChatSession} = redgoose.models

module.exports = (res, chatId) ->
  operatorId = unescape(res.cookie('session'))

  ChatSession.remove operatorId, chatId, (err) ->
    res.send err, chatId
