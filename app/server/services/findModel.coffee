module.exports =
  required: ['sessionId', 'sessionSecret', 'modelName']
  optional: ['queryObject']
  service: ({queryObject, sessionId, sessionSecret, modelName}, done) ->
    queryObject ||= {}
    findModel = config.service 'model/findModel'
    findModel {queryObject: queryObject, modelName: modelName}, done
