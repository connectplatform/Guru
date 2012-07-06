module.exports = (res) ->
  sendChatsFromIdList = require '../sendChatsFromIdList'
  redgoose = require 'redgoose'
  {Chat} = redgoose.models

  Chat.allChats.all (err, rawData) ->
    sendChatsFromIdList res, err, rawData