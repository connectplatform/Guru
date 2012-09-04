async = require 'async'
stoic = require 'stoic'

# TODO: code review
getChatsFromIdList = (list, done) ->
  {Chat, ChatSession} = stoic.models

  chatIDs = list

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
          chatSession.session.chatName.get
        ], (err, [isWatching, role, chatName]) ->

          if isWatching is 'true' or role is 'Visitor'
            value = null
          else
            value = chatName

          cb err, value

      async.map chatSessions, getVisibleOperators, (err, visibleOperators) ->
        chat.operators = visibleOperators.filter (element) -> element != null
        next err, chat

  async.map chatIDs, getChat, done

chatOrder = (chat) ->
  status = chat.relation or chat.status
  ['transfer', 'invite', 'waiting', 'active', 'vacant'].indexOf status

module.exports = (res) ->
  {Chat, ChatSession} = stoic.models
  Chat.allChats.all (err, chats) ->
    getChatsFromIdList chats, (err1, chats) ->

      # only look these up once for all chats we're checking
      chatIds = chats.map (chat) -> chat.id

      # map chat statuses
      assignStatus = (myChatSession, cb) ->
        myChatSession.relationMeta.get 'type', (err, type) ->
          if type in ['invite', 'transfer', 'member']

            # change status of chat in chats that has the same id as this
            chatIndex = chatIds.indexOf myChatSession.chatId
            if chatIndex < 0
              console.log "Warning: chat disappeared while we were using it in getActiveChats"
            else
              chats[chatIndex].relation = type
          cb()

      ChatSession.getBySession res.cookie('session'), (err, myChatSessions) ->
        async.forEach myChatSessions, assignStatus, (err) ->
          chats = chats.sortBy chatOrder
          res.reply err, chats
