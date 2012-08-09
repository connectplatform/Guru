{digest_s} = require 'md5'
db = require '../../mongo'
{User} = db.models

module.exports = (res, fields, modelName) ->
  Model = db.models[modelName]

  getModel = (fields, cb) ->
    if fields.id?
      Model.findOne {_id: fields.id}, (err, foundModel) ->
        return res.send err, null if err?
        cb foundModel
    else
      #TODO: generate a random password that we can email to the user
      userModel = new Model
      userModel.password = digest_s 'password'
      cb userModel

  getModel fields, (foundModel) ->
    foundModel[key] = value for key, value of fields when key isnt 'id'
    foundModel.save (err) ->
      console.log "error saving #{model} model: #{err}" if err?

      filterModel = (aModel) ->
        newUser = {id: aModel['_id']}
        newUser[key] = value for key, value of aModel._doc when key isnt 'password' and key isnt '_id'
        newUser

      res.send err, filterModel foundModel
