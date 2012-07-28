async = require 'async'
redgoose = require 'redgoose'
{tandoor} = require '../../../lib/util'
{Chat, Session} = redgoose.models

# Interface for document
face = ({chatSession: {chatIndex, sessionIndex, relationMeta}}) ->

  # get a chatSession
  get = (sessionId, chatId) ->

    # base object
    chatSession = sessionId: sessionId, chatId: chatId

    # accessors
    chatIndex chatSession
    sessionIndex chatSession
    relationMeta chatSession

    # relations
    chatSession.session = Session.get sessionId
    chatSession.chat = Chat.get chatId

    chatSession

  # construct model
  chatSession =

    get: get

    add: tandoor (sessionId, chatId, metaInfo, cb) ->
      cs = get sessionId, chatId

      async.parallel [
        cs.sessionIndex.add chatId
        cs.chatIndex.add sessionId
        cs.relationMeta.mset metaInfo

      ], (err) ->
        console.log "Error adding chatSession: #{err}" if err?
        cb err, cs

    remove: tandoor (sessionId, chatId, cb) ->
      cs = get sessionId, chatId

      async.parallel [
        cs.sessionIndex.srem chatId
        cs.chatIndex.srem sessionId
        cs.relationMeta.del

      ], (err) ->
        console.log "Error removing chatSession: #{err}" if err?
        cb err, cs

    getBySession: tandoor (sessionId, cb) ->
      get(sessionId).sessionIndex.members (err, chatIds) ->
        result = (get sessionId, chatId for chatId in chatIds)
        cb err, result

    getByChat: tandoor (chatId, cb) ->
      get(null, chatId).chatIndex.members (err, sessionIds) ->
        result = (get sessionId, chatId for sessionId in sessionIds)
        cb err, result

  return chatSession

# Schema for document
schema =

  'chatSession':
    'sessionIndex:!{sessionId}': 'Set'
    'chatIndex:!{chatId}': 'Set'
    'relationMeta:!{sessionId}:!{chatId}': 'Hash'
    # meta keys: isWatching: true|false
    #            type: member|invite|transfer
    #            requestor: sessionID (optional)

module.exports = ['ChatSession', face, schema]
