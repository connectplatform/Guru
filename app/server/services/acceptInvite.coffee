db = config.require 'load/mongo'
{ChatSession, Session} = db.models

module.exports =
  required: ['sessionSecret', 'chatId']
  service: ({sessionSecret, chatId}, done) ->
    Session.findOne {secret: sessionSecret}, (err, session) ->
      return done err, null if err or not session?
      
      sessionId = session._id
      ChatSession.findOne {sessionId, chatId}, (err, chatSession) ->
        return done err, null if err or not chatSession

        chatSession?.relation = 'Member'
        chatSession?.save done
