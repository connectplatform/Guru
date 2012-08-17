async = require 'async'
createChannel = require '../createChannel'
redgoose = require 'redgoose'

module.exports = (res, userData) ->
  username = userData.username or 'anonymous'

  {Chat, Session, ChatSession} = redgoose.models
  Chat.create (err, chat) ->
    console.log "error creating chat: #{err}" if err
    chatId = chat.id

    #TODO: move this up to middleware
    Session.create {role: 'Visitor', chatName: username}, (err, session) ->
      console.log "error creating session: #{err}" if err
      sessionId = session.id
      res.cookie 'session', sessionId

      relationMeta = {
        isWatching: false,
        type: 'member'
      }

      ChatSession.add sessionId, chatId, relationMeta, (err) ->
        console.log "error creating sessionChat: #{err}" if err

        visitorMeta =
          username: username
          website: null
          department: null

        async.series [
          chat.visitor.set visitorMeta

        ], (err) ->
          console.log "redis error in newChat: #{err}" if err

          createChannel chatId

          res.reply null, channel: chatId
