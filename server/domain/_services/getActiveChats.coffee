async = require 'async'
redgoose = require 'redgoose'
{Chat} = redgoose.models

getChatsFromIdList = (list, done) ->

  #this is a bogus chatID added by the redis query TODO: should I worry about this?
  chatIDs = list.filter (element) -> element != 'true'

  getChat = (chatID, next) ->
    Chat.get(chatID).dump (err, chat) ->
      console.log "Error getting chat from cache: chatID: #{chatID}, error:#{err}" if err?
      message.timestamp = new Date(parseInt(message.timestamp)) for message in chat.history

      # get chats I've been invited to

      chat.accept = (chat.status in ['invite', 'transfer', 'waiting'])

      # state = transfer, invite, waiting, active, vacant
      next err, chat

  async.map chatIDs, getChat, done

module.exports = (res) ->
  Chat.allChats.all (err, rawData) ->
    getChatsFromIdList rawData, res.send

