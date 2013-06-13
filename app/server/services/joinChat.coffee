db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models

module.exports =
  required: ['sessionSecret', 'sessionId', 'chatId']
  optional: ['relation']
  service: ({sessionId, chatId, relation}, done) ->
    # default relation for joining a chat is Membership
    relation = 'Member' unless relation?

    # data for creating the ChatSession, if referentially integral
    data =
      sessionId: sessionId
      chatId: chatId
      relation: relation

    # Verify Session matching sessionId exists
    Session.findById sessionId, (err, session) ->
      return done err if err
      return done (new Error "Couldn't find Session") if not session?

      # Verify Chat matching chatId exists
      Chat.findById chatId, (err, chat) ->
        return done err if err
        return done (new Error "Couldn't find Chat") if not chat?

        ChatSession.create data, (err, chatSession) ->
          return done err, {status: 'ERROR'} if err

          status = 'OK'
          # If an Operator is joining the chat
          if session.userId?
            # Change Chat status to 'Active'
            chat.status = 'Active'
            chat.save (err) ->
              done err, {status: status}
          else
            # Otherwise the Chat is still Waiting for an Operator
            done err, {status: 'OK'}
