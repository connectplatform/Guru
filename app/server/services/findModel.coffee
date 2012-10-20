getAccountId = config.require 'services/account/getAccountId'
findModel = config.require 'services/model/findModel'

module.exports = (res, queryObject, modelName) ->
  getAccountId res.cookie('session'), (err, accountId) ->
    findModel accountId, queryObject, modelName, res.reply
