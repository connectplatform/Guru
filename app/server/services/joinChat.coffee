db = config.require 'load/mongo'
{Chat, ChatSession} = db.models

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

    ChatSession.create data, (err, chatSession) ->
      return done err, {status: 'ERROR'} if err

      # What happens next depends on who is joining the Chat, and how.
      # 
      # relation | description 
      # ---------+------------
      # Member   | Op. visibly joining the Chat, which must have status Active
      # Invite   | Op. invited to the Chat, no change in status
      # Transfer | Op. is being asked to accept a transfer, no change in status
      # Watching | Op. is invisibly(!) joining the Chat, no change in status
      # Visitor  | Visitor is visibly joining the Chat, no change in status
      status = 'OK'

      # As described above, changes to the Chat instance are only
      # required if relation is Member.
      return done err, {status} unless relation is 'Member'
      
      # Now an Operator is visibly joining the chat, so change
      # the Chat status to Active
      Chat.findById chatId, (err, chat) ->
        return done err if err
        return done (new Error 'Chat not found') if not chat?
          
        chat?.status = 'Active'
        chat?.save (err) ->
            done err, {status}
