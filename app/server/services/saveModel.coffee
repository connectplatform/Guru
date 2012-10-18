db = config.require 'load/mongo'
getAccountId = config.require 'services/account/getAccountId'
globalModels = config.require 'load/globalModels'

parseMongooseError = (err) ->
  return null unless err?
  message = ""
  if err?.errors
    for field, info of err.errors
      message += "#{info.message}\n"
    return message
  else
    return "Model error"

module.exports = (res, fields, modelName) ->
  getAccountId res.cookie('session'), (err, accountId) ->

    unless modelName in globalModels
      return res.reply 'Could not determine account ID.' unless accountId
      fields.merge accountId: accountId

    Model = db.models[modelName]

    {createFields, filterOutput} = config.require "models/#{modelName}Filters"

    # get or create
    getRecord = (fields, cb) ->
      if fields.id?
        Model.findOne {_id: fields.id}, (err, foundModel) ->
          cb err, foundModel
      else
        cb null, createFields new Model

    # update field data
    getRecord fields, (err, foundModel) ->
      return res.reply err, null if err?
      foundModel[key] = value for key, value of fields when key isnt 'id'
      foundModel.save (err, savedModel) ->
        savedModel = filterOutput savedModel unless err?
        res.reply parseMongooseError(err), savedModel
