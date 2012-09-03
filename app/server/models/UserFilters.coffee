{digest_s} = require 'md5'

module.exports =
  createFields: (inModel) ->
    #TODO: generate a random password that we can email to the user
    outModel = inModel
    outModel.password = digest_s 'password'
    outModel

  filterOutput: (inModel) ->
    outModel = {id: inModel['_id']}
    outModel[key] = value for key, value of inModel._doc when key isnt 'password' and key isnt '_id'
    outModel
