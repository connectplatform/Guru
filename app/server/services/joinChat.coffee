db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models

module.exports =
  required: ['sessionId', 'chatId']
  optional: ['relation']
  service: ({sessionId, chatId}, done) ->
    data =
      sessionId: sessionId
      chatId: chatId
      relation: 'Member'
    Session.findById sessionId, (err, session) ->
      if session?
        Chat.findById chatId, (err, chat) ->
          if chat?
            ChatSession.create data, (err, chatSession) ->
              status = if err then 'ERROR' else 'OK'
              done err, {status: status}
          else
            err = "Couldn't find Chat"
            done err, null
      else
        err = "Couldn't find Session"
        done err, null