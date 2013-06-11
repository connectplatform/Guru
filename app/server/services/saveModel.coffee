db = config.require 'load/mongo'
enums = config.require 'load/enums'
parseMongooseError = config.require 'load/helpers/parseMongooseError'

module.exports =
  required: ['accountId', 'modelName', 'fields']
  service: ({accountId, modelName, fields}, done) ->
    # Somewhat of a hack but not sure where else to put this.
    # Maybe the CRUD services could be controlled by a data structure?
    if modelName is 'User' and fields.role and fields.role not in enums.editableRoles and not fields.id
      return done "Cannot create a #{fields.role} user."
    fields.merge accountId: accountId
    Model = db.models[modelName]
    {createFields, filterOutput} = config.require "models/#{modelName}Filters"

    # get or create
    getRecord = (fields, cb) ->
      if fields.id
        Model.findOne {_id: fields.id}, (err, foundModel) ->
          return cb err if err
          foundModel[key] = value for key, value of fields when key isnt 'id'
          createFields foundModel, cb

      else
        createFields new Model(fields), cb

    # update field data
    getRecord fields, (err, foundModel) ->
      return done err, null if err

      foundModel.save (err, savedModel) ->
        err = parseMongooseError(err, fields, modelName)
        return done err, savedModel if err
        filterOutput savedModel, done
