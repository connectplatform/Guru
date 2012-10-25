getAccountId = config.require 'services/account/getAccountId'
findModel = config.require 'services/model/findModel'

#TODO: implement as required param
#filters: ['firstArgumentIsObject']
module.exports = (res, queryObject, modelName) ->
  getAccountId res.cookie('session'), (err, accountId) ->
    findModel accountId, queryObject, modelName, res.reply
