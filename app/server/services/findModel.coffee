getAccountId = config.require 'services/account/getAccountId'
findModel = config.require 'services/model/findModel'

#TODO: implement as required param
#filters: ['firstArgumentIsObject']
module.exports = ({queryObject, modelName, sessionId}, done) ->
  getAccountId sessionId, (err, accountId) ->
    findModel accountId, queryObject, modelName, done
