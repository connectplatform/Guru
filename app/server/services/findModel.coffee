module.exports =
  required: ['sessionId', 'accountId', 'modelName']
  optional: ['queryObject']
  service: ({queryObject, modelName, sessionId, accountId}, done) ->
    queryObject ||= {}
    findModel = config.service 'model/findModel'
    findModel {accountId: accountId, queryObject: queryObject, modelName: modelName}, done
