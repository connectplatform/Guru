db = config.require 'load/mongo'
getAccountId = config.require 'services/account/getAccountId'
globalModels = config.require 'load/globalModels'
enums = config.require 'load/enums'

parseMongooseError = (err) ->
  return null unless err?
  message = ""
  if err?.errors
    for field, info of err.errors
      message += "#{info.message}\n"
    return message
  else
    return "Model error"

#TODO: implement as required param
#filters: ['firstArgumentIsObject']
module.exports = ({fields, modelName, sessionId}, done) ->

  # Somewhat of a hack but not sure where else to put this.  Maybe the CRUD services could be controlled by a data structure?
  return done "Cannot create a #{fields.role} user." if modelName is 'User' and fields.role and fields.role not in enums.editableRoles

  getAccountId sessionId, (err, accountId) ->

    unless modelName in globalModels
      return done 'Could not determine account ID.' unless accountId
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
      return done err, null if err?
      foundModel[key] = value for key, value of fields when key isnt 'id'

      foundModel.save (err, savedModel) ->
        savedModel = filterOutput savedModel unless err?
        done parseMongooseError(err), savedModel
