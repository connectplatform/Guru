{inspect} = require 'util'
async = require 'async'
redgoose = require 'redgoose'
{Chat, OperatorChat} = redgoose.models

getChatsFromIdList = (list, done) ->

  #this is a bogus chatID added by the redis query TODO: should I worry about this?
  chatIDs = list.filter (element) -> element != 'true'

  # get chats I've been invited to
  invites =
    chatID: 'invite'
    otherChatID: 'transfer'

  getChat = (chatID, next) ->

    async.parallel [
      Chat.get(chatID).dump
      OperatorChat.getOperatorsByChat chatID

    ], (err, [chat, operators]) ->
      console.log "Error getting chat from cache: chatID: #{chatID}, error:#{err}" if err?
      message.timestamp = new Date(parseInt(message.timestamp)) for message in chat.history
      chat.relation = undefined # o.getMeta for o in operators
      chat.operators = if operators? then (o for o, watching of operators when watching is 'false') else []
      next err, chat

  async.map chatIDs, getChat, done

module.exports = (res) ->
  Chat.allChats.all (err, chats) ->
    getChatsFromIdList chats, res.send
