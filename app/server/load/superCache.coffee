watcher = config.require 'load/mongoWatch'
logger = config.require 'lib/logger'
{getType, hasKeys, includes} = config.require 'lib/util'
cache = config.require 'load/relationsCache'

watcher.watch "#{config.mongo.dbName}.sessions", (event) ->
  #logger.grey 'event:'.cyan, event

  for op in event.oplist
    if op.operation is 'set' and op.path is '.'
      cache.set 'sessionId', op.id, {accountId: op.data.accountId}

watcher.watch "#{config.mongo.dbName}.chats", (event) ->
  #logger.grey 'event:'.cyan, event

  for op in event.oplist
    if op.operation is 'set' and op.path is '.'
      cache.set 'chatId', op.id, {accountId: op.data.accountId}
      cache.set 'chatId', op.id, {websiteId: op.data.websiteId}
      cache.set 'chatId', op.id, {specialtyId: op.data.specialtyId}

watcher.watch "#{config.mongo.dbName}.chatsessions", (event) ->

  for op in event.oplist
    if op.operation is 'set' and op.path is '.'
      cache.set 'chatId', op.data.chatId, {sessionId: op.data.sessionId}
      cache.set 'chatSessionId', op.id, {chatId: op.data.chatId, sessionId: op.data.sessionId}

    else if op.operation is 'unset' and op.path is '.'
      rel = cache.findOne 'chatSessionId', op.id
      if rel?
        {sessionId, chatId} = rel
        cache.unset 'chatId', chatId, {sessionId}
        cache.unset 'chatSessionId', op.id

module.exports =

  # get needs to return the value if present,
  # otherwise wait up to {timeout} for the value to appear
  get: ({key, value, expected}, done) ->
    expected or= []
    expected = [expected] unless getType(expected) is 'Array'

    # retrieve current relations and collapse into a single object
    getVal = ->
      relations = cache.get key, value
      combined = {}
      for rel in relations
        for k, v of rel
          if combined[k]?
            unless getType(combined[k]) is 'Array'
              combined[k] = [combined[k]]
            combined[k].push v
          else
            combined[k] = v
      return combined

    # might send, will report back status
    sendIfPresent = ->
      result = getVal()
      if hasKeys result, expected
        done null, result
        return true
      return false

    return if sendIfPresent()

    # to be run whenever a new cache value is received
    check = (update) ->
      #logger.grey 'update:'.cyan, update
      if update.key is key and update.value is value
        if sendIfPresent()
          cache.removeListener 'set', check
          clearTimeout idx

    # to be run when timeout is hit
    lastChance = ->
      unless sendIfPresent()
        done null, getVal()
      cache.removeListener 'set', check

    idx = setTimeout lastChance, 200
    cache.on 'set', check
