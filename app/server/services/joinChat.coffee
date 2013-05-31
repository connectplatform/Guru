db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models

module.exports =
  required: ['sessionId', 'chatId']
  optional: ['relation']
  service: ({sessionId, chatId, relation}, done) ->
    relation = 'Member' unless relation?
    data =
      sessionId: sessionId
      chatId: chatId
      relation: relation
    Session.findById sessionId, (err, session) ->
      if session?
        Chat.findById chatId, (err, chat) ->
          if chat?
            ChatSession.create data, (err, chatSession) ->
              status = if err then 'ERROR' else 'OK'
              # If an Operator is joining the chat
              if session.userId?
                # Change status to 'Active'
                chat.status = 'Active'
                chat.save (err) ->
                  done err, {status: status}
              else
                # Otherwise the Chat is still Waiting for an Operator
                done err, {status: status}
          else
            err = "Couldn't find Chat"
            done err, null
      else
        err = "Couldn't find Session"
        done err, null