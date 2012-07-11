async = require 'async'
createChannel = require '../createChannel'
redgoose = require 'redgoose'

module.exports = (res, data) ->
  username = data.username or 'anonymous'

  {Chat, Session} = redgoose.models
  Chat.create (err, chat) ->
    console.log "error creating chat: #{err}" if err
    channelName = chat.id

    sessionId = unescape(res.cookie('session'))

    #TODO: move this up to middleware
    Session.create {role: 'visitor', chatName: username}, (err, session) ->
      console.log "error creating session: #{err}" if err
      sessionId = session.id
      res.cookie 'session', sessionId

      visitorMeta =
        username: username
        website: null
        department: null

      async.series [
        chat.visitor.set visitorMeta
        chat.visitorPresent.set 'true'

      ], (err) ->
        console.log "redis error in newChat: #{err}" if err

        createChannel channelName

        res.cookie 'channel', channelName
        res.send null, channel: channelName
