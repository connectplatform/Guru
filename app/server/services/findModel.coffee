module.exports =
  required: ['sessionId', 'accountId', 'queryObject', 'modelName']
  service: ({queryObject, modelName, sessionId, accountId}, done) ->
    findModel = config.service 'model/findModel'
    console.log 'accountId:', accountId
    findModel {accountId: accountId, queryObject: queryObject, modelName: modelName}, done
