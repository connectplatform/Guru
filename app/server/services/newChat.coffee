async = require 'async'
stoic = require 'stoic'

createChannel = config.require 'services/createChannel'
populateVisitorAcpData = config.require 'services/populateVisitorAcpData'

module.exports = (res, userData) ->
  username = userData.username or 'anonymous'

  {Chat, Session, ChatSession} = stoic.models
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
          department: null
          referrerData: userData.referrerData || null

        async.series [
          chat.visitor.mset visitorMeta

        ], (err) ->
          console.log "redis error in newChat: #{err}" if err

          createChannel chatId

          res.reply null, channel: chatId

          #We don't want the visitor to have to wait on this
          if userData.referrerData
            populateVisitorAcpData userData.referrerData, chatId
