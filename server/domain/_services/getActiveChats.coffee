async = require 'async'
redgoose = require 'redgoose'

getChatsFromIdList = (list, done) ->
  {Chat, ChatSession} = redgoose.models

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
  {Chat, ChatSession} = redgoose.models
  Chat.allChats.all (err, chats) ->
    getChatsFromIdList chats, (err1, chats) ->

      #only look these up once for all chats we're checking
      chatIds = chats.map (chat) -> chat.id
      #map chat statuses
      assignStatus = (myChatSession, cb) ->
        myChatSession.relationMeta.get 'type', (err, type) ->
          if type is 'invite' or type is 'transfer'
            #change status of chat in chats that has the same id as this
            chatIndex = chatIds.indexOf myChatSession.chatId
            if chatIndex < 0
              console.log "Warning: chat disappeared while we were using it in getActiveChats"
            else
              chats[chatIndex].status = type
          cb()

      ChatSession.getBySession res.cookie('session'), (err, myChatSessions) ->
        async.forEach myChatSessions, assignStatus, (err) ->
          res.send err, chats
