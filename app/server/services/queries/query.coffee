stoic = require 'stoic'
async = require 'async'
{queryArray, getType} = config.require 'load/util'

{ChatSession, Session, Chat} = stoic.models
modelsByName =
  chatSession: ChatSession
  chat: Chat
  session: Session

getBaseModel = (from, all) ->
  models = (parts[0] for parts in all)
  if from
    modelName = from
  else if ('chatSession' in models) or (('chat' in models) and ('session' in models))
    modelName = 'chatSession'
  else
    modelName = models[0]
  modelName

getNeededData = (query, cb) -> 
  neededFields = {where: [], select: []}
  if query.where
    neededFields.select.push keypath.split '.' for keypath of query.where
  if query.select
    neededFields.where.push keypath.split '.' for alias, keypath of query.select
  neededFields.all = neededFields.select.concat neededFields.where
  neededFields.baseModel = getBaseModel query.from, neededFields.all
  cb null, neededFields

packNeededData = (accountId, ids, neededFields, cb) ->

  packValues = (values, model) ->
    result = []
    for value in values
      wrapped = ids:
        chatId: value.chatId
        sessionId: value.sessionId
      wrapped.ids.chatId = value.id if model is 'chat'
      wrapped.ids.sessionId = value.id if model is 'session'
      wrapped[model] = value
      result.push wrapped
    return result

  populate = (cb) ->
    element = modelsByName[neededFields.baseModel](accountId).get ids
    if getType(element) is 'Function'
      element (err, values) ->
        cb err, packValues values, neededFields.baseModel
    else
      cb null, packValues [element], neededFields.baseModel

  addField = (model, field, rest) ->
    (dataObject, cb) ->
      theseIds = dataObject.ids or ids

      instance = modelsByName[model](accountId).get theseIds

      # Make sure the model entry exists
      dataObject[model] = {} unless dataObject[model]?

      # Check whether the field exists
      #return cb() if dataObject[model][field]? and rest.length is 0
      return cb() unless instance[field]?.retrieve?

      # If we don't have a field specified then we want to dump everything
      unless field?
        instance.dump (err, data) ->
          dataObject[model] = data
          return cb err

      # field or field contents don't exist, get them

      instance[field].retrieve (err, data) ->
        if getType(data) is 'Object'
          dataObject[model][field] ?= {}
          dataObject[model][field][key] = value for key, value of data
        else
          dataObject[model][field] = data
        cb err

  augment = (baseData) ->
    (neededField, cb) ->
      [model, field, rest...] = neededField

      async.forEach baseData, addField(model, field, rest), (err) ->
        cb err

  populate (err, dataToQuery) ->
    async.forEach neededFields.all, augment(dataToQuery), (err) ->
      cb null, dataToQuery

module.exports = ({accountId, queries}, done) ->
  results = {}
  run = (alias, cb) ->
    query = queries[alias]
    getNeededData query, (err, neededFields) ->
      packNeededData accountId, query.ids, neededFields, (err, dataToQuery) ->
        results[alias] = queryArray dataToQuery, query
        cb err

  async.forEach Object.keys(queries), run, (err) ->
    done err, results
