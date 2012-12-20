Vein = require 'vein'
stoic = require 'stoic'
{Session, Chat} = stoic.models

# accept an http server which we will attach to
module.exports = (server) ->
  vein = Vein.createServer server: server

  # When a user or visitor loses connection (closing browser, network issues, etc) we set session offline
  vein.on 'close', (socket) ->
    setSessionOffline = config.service 'setSessionOffline'
    leaveChat = config.service 'leaveChat'

    # TODO: Review, do we want to make this a service or integrate it into a service?
    # Or do something else?

    # Lookup sessionId based on socketId
    Session.sessionLookup.get socket.id, (err, sessionId) ->
      if err or not sessionId?
        return config.log.error 'Error looking matching socket ID to session ID',
          error: err,
          socketId: socket.id,
          sessionId: sessionId

      # Lookup account based on sessionId
      Session.accountLookup.get sessionId, (err, accountId) ->
        if err or not accountId?
          return config.log.error 'Error looking up account',
            error: err,
            sessionId: sessionId,
            accountId: accountId

        # Get all associated chats for account
        Chat(accountId).allChats.all (err, chats) ->
          if err or not chats?
            return config.log.error 'Error looking up chats',
              error: err,
              sessionId: sessionId,
              accountId: accountId

          # Leave all the chats
          for chatId, i in chats
            leaveChat {sessionId: sessionId, chatId: chatId, accountId: accountId}, (err) ->
              if err
                config.log.error 'Error leaving chat',
                  error: err,
                  sessionId: sessionId,
                  accountId: accountId,
                  chatId: chatId

            if i is chats.length - 1

              # Set session offline
              setSessionOffline {sessionId: sessionId}, (err) ->
                if err
                  config.log.error 'Error setting session offline',
                    error: err,
                    sessionId: sessionId

  # accept a set of services
  (services) ->
    Object.map services, (name, service) ->

      # wrap each service in a vein signature and attach it to vein
      vein.add name, (res, args) ->

        # define a function to process side effects
        processSideEffects = (effects, next) ->
          if effects?.setCookie?.sessionId
            res.cookie 'session', effects.setCookie.sessionId
          next()

        # merge cookies into args
        params = {sessionId: res.cookie 'session'}.merge args

        # run the service
        service params, res.reply, processSideEffects
