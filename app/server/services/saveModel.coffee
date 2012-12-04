db = config.require 'load/mongo'
getAccountId = config.require 'services/account/getAccountId'
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

module.exports =
  required: ['sessionId', 'accountId', 'fields', 'modelName']
  service: ({fields, modelName, sessionId, accountId}, done) ->

    # Somewhat of a hack but not sure where else to put this.  Maybe the CRUD services could be controlled by a data structure?
    if modelName is 'User' and fields.role and fields.role not in enums.editableRoles and not fields.id
      return done "Cannot create a #{fields.role} user."

    fields.merge accountId: accountId
    Model = db.models[modelName]
    {createFields, filterOutput} = config.require "models/#{modelName}Filters"

    # get or create
    getRecord = (fields, cb) ->
      if fields.id
        Model.findOne {_id: fields.id}, (err, foundModel) ->
          cb err if err
          createFields foundModel, cb
      else
        createFields new Model, cb

    # update field data
    getRecord fields, (err, foundModel) ->
      return done err, null if err?
      foundModel[key] = value for key, value of fields when key isnt 'id'

      foundModel.save (err, savedModel) ->
        return done parseMongooseError(err), savedModel if err
        filterOutput savedModel, done
