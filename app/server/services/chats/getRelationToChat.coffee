db = config.require 'load/mongo'
{ChatSession, Session} = db.models

module.exports =
  required: ['sessionSecret', 'chatId']
  service: ({chatId, sessionSecret}, next) ->
    Session.findOne {secret: sessionSecret}, (err, session) ->
      return done err if err or not session?

      sessionId = session._id
      ChatSession.findOne {chatId, sessionId}, (err, chatSession) ->
        if err?
          next err, null
        else if chatSession?
          next null, {relation: chatSession.relation}
        else
          next null, null