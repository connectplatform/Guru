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
    neededFields.where.push keypath.split '.' for keypath of query.where
  if query.select
    neededFields.select.push keypath.split '.' for alias, keypath of query.select
  neededFields.all = neededFields.select.concat neededFields.where
  neededFields.baseModel = getBaseModel query.from, neededFields.all
  cb null, neededFields

packNeededData = (accountId, ids, neededFields, cb) ->

  # transform query into standard format to be parsed internally
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

  # grab data from the stoic model
  populate = (cb) ->
    element = modelsByName[neededFields.baseModel](accountId).get ids
    if getType(element) is 'Function'
      element (err, values) ->
        cb err, packValues values, neededFields.baseModel
    else
      cb null, packValues [element], neededFields.baseModel

  # grab data from a specific field
  # this function causes side effects on the dataObject, and does not return any data through the callback
  addField = (dataObject) ->
    ([model, field, rest], cb) ->

      theseIds = dataObject.ids or ids

      unless modelsByName[model]
        config.log.error 'Query for invalid model', model: model
        return cb "Invalid model #{model}"
      instance = modelsByName[model](accountId).get theseIds

      # Make sure the model entry exists
      dataObject[model] = {} unless dataObject[model]?

      unless field?
        # If we don't have a field specified then we want to dump everything
        instance.dump (err, data) ->
          dataObject[model] = data if data
          config.log.error "Error dumping data in query", {error: err, model: model, field: field} if err
          return cb err
      else
        # Check whether the field is valid
        unless instance[field]
          config.log.error 'Query for invalid field', {model: model, field: field}
          return cb "Invalid field #{field}"

        # We're done if the field isn't something that can be queried
        unless instance[field].retrieve
          #config.log "no data for #{field}"
          return cb()

        # field or field contents don't exist, get them
        instance[field].retrieve (err, data) ->
          {inspect} = require 'util'
          config.log.error "Error retrieving data in query", {error: err, model: model, field: field} if err
          if getType(data) is 'Object'
            dataObject[model][field] ?= {}
            dataObject[model][field][key] = value for key, value of data
          else
            dataObject[model][field] = data
          cb err

  populate (err, dataToQuery) ->

    # pack all the needed fields into the data item
    augment = (dataItem, cb) ->
      async.forEach neededFields.all, addField(dataItem), (err) ->

        # don't blow up the query if you can't find something, just blank this item
        # nulls will be removed from the final list
        if err
          cb()
        else
          cb null, dataItem

    # augment all data items
    async.map dataToQuery, augment, (err, data) ->
      cb err, data.compact()

module.exports = ({accountId, queries}, done) ->
  results = {}
  run = (alias, cb) ->
    constraints = queries[alias]
    getNeededData constraints, (err, neededFields) ->
      packNeededData accountId, constraints.ids, neededFields, (err, dataToQuery) ->
        results[alias] = queryArray dataToQuery, constraints
        cb err

  # TODO: should be a reduce, not a forEach
  async.forEach Object.keys(queries), run, (err) ->
    done err, results
