async = require 'async'
{tandoor} = config.require 'load/util'
pulsar = config.require 'load/pulsar'
getInvites = config.require 'services/getInvites'

stoic = require 'stoic'
{Chat, Session} = stoic.models

# Interface for document
face = ({chatSession: {chatIndex, sessionIndex, relationMeta}}) ->

  # get a chatSession
  get = (sessionId, chatId) ->

    # base object
    chatSession = sessionId: sessionId, chatId: chatId

    # accessors
    chatIndex chatSession, ({after}) ->
      after ['members'], (context, sessionIds, next) ->
        next null, (get sessionId, chatId for sessionId in sessionIds)

    sessionIndex chatSession, ({after}) ->
      after ['members'], (context, chatIds, next) ->
        next null, (get sessionId, chatId for chatId in chatIds)

    relationMeta chatSession, ({before}) ->
      before ['mset', 'set'], (context, args, next) ->
        getInvites chatSession, (err, chats) ->
          notify = pulsar.channel "notify:session:#{sessionId}"
          notify.emit 'newInvites', chats

        next null, args

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

    # just sugar
    getBySession: tandoor (sessionId, cb) ->
      get(sessionId).sessionIndex.members cb

    getByChat: tandoor (chatId, cb) ->
      get(null, chatId).chatIndex.members cb

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