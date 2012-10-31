stoic = require 'stoic'
async = require 'async'
{queryArray, getType} = config.require 'load/util'

{ChatSession, Session, Chat} = stoic.models

getNeededData = (queries, cb) -> 
  neededFields = []
  for name, query of queries
    if query.where
      neededFields.push keypath.split '.' for keypath of query.where
    if query.select
      neededFields.push keypath.split '.' for alias, keypath of query.select
  cb null, neededFields

packNeededData = (accountId, chatId, neededFields, cb) ->

  populate = (cb) ->
    ChatSession(accountId).getByChat chatId, (err, chatSessions) ->
      config.log.error 'Error getting chatSessions in queryChat', {error: err, chatId: chatId, accountId: accountId} if err

      result = []
      for chatSession in chatSessions
        result.push chatSession: chatSession

      cb null, result

  addField = (model, field, rest) ->
    (dataObject, cb) ->
      if model is 'chatSession'
        instance = dataObject.chatSession
      else if model is 'session'
        instance = Session(accountId).get dataObject.chatSession.sessionId
      else if model is 'chat'
        instance = Chat(accountId).get dataObject.chatSession.chatId
      else return cb 'Invalid model given in query: ', model

      # Make sure the model entry exists
      dataObject[model] = {} unless dataObject[model]?

      # Check whether the field exists
      return cb() if dataObject[model][field]? and not rest

      # If we just want an id just copy it over
      if field is 'chatId'
        dataObject[model][field] = dataObject.chatSession[field]
        return cb()
      if field is 'sessionId'
        dataObject[model][field] = dataObject.chatSession[field]
        return cb()

      # field or field contents don't exist, get them
      instance[field].retrieve (err, data) ->
        if getType(data) is 'Object'
          dataObject[model][field] ?= {}
          dataObject[model][field][key] = value for key, value of data
        else
          dataObject[model][field] = data
        cb()

  augment = (baseData) ->
    (neededField, cb) ->
      [model, field, rest...] = neededField

      async.forEach baseData, addField(model, field, rest), (err) ->
        cb err

  populate (err, dataToQuery) ->
    async.forEach neededFields, augment(dataToQuery), (err) ->
      cb null, dataToQuery

module.exports = ({accountId, chatId, queries}, done) ->
  getNeededData queries, (err, neededFields) ->
    packNeededData accountId, chatId, neededFields, (err, dataToQuery) ->
      done err, queryArray dataToQuery, queries
