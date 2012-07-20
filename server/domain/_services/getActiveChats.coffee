async = require 'async'
redgoose = require 'redgoose'
{Chat, ChatSession} = redgoose.models

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
      ChatSession.getByChat chatID

    ], (err, [chat, chatSessions]) ->
      console.log "Error getting chat from cache: chatID: #{chatID}, error:#{err}" if err?
      message.timestamp = new Date(parseInt(message.timestamp)) for message in chat.history
      chat.relation = undefined # myChatSession.type

      # unholy terror, abandon hope
      getVisibleOperators = (chatSession, cb) ->
        async.parallel [
          chatSession.relationMeta.get 'isWatching'
          chatSession.session.role.get
        ], (err, [isWatching, role]) ->

          if isWatching is 'true' or role is 'Visitor'
            value = null
          else
            value = chatSession.sessionId

          cb err, value

      async.map chatSessions, getVisibleOperators, (err, visibleOperators) ->
        chat.operators = visibleOperators.filter (element) -> element != null
        next err, chat

  async.map chatIDs, getChat, done

module.exports = (res) ->
  Chat.allChats.all (err, chats) ->
    getChatsFromIdList chats, res.send
