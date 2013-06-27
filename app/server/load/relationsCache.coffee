{EventEmitter} = require 'events'
{getType, hasKeys, includes} = config.require 'lib/util'
logger = config.require 'lib/logger'

# private API
cache = {}

notify = (emitter, event) ->
  process.nextTick ->
    emitter.emit 'update', event

cleanup = (key, value) ->
  if cache[key][value].length is 0
    delete cache[key][value]
    if cache[key].keys().length is 0
      delete cache[key]

# public API
class Cache extends EventEmitter
  import: (data) ->
    cache.merge data

  clear: ->
    cache = {}

  get: (key, value) ->
    cache?[key]?[value] or []

  findOne: (key, value, search) ->
    relations = @get key, value
    return relations.find (r) -> includes r, search

  findIndex: (key, value, search) ->
    relations = @get key, value
    return relations.findIndex (r) -> includes r, search

  set: (key, value, relation) ->
    unless @findIndex(key, value, relation) > -1
      cache[key] or= {}
      cache[key][value] or= []
      cache[key][value].push relation
      notify @, {key, value, relation, type: 'set'}
      #logger.grey 'set cache:'.yellow, cache


  unset: (key, value, relation) ->
    relations = @get key, value
    if relations?

      # if no target relation was provided, delete them all
      unless relation?
        cache[key][value] = []
        cleanup key, value
        notify @, {key, value, relation, type: 'unset'}

      # otherwise look for the relation and delete it
      else
        index = @findIndex(key, value, relation)
        if index > -1
          relations.removeAt index
          cleanup key, value
          notify @, {key, value, relation, type: 'unset'}

module.exports = new Cache
