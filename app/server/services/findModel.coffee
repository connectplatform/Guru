module.exports =
  dependencies:
    services: ['model/findModel']
  required: ['accountId', 'modelName']
  optional: ['queryObject']
  service: ({accountId, modelName, queryObject}, done, {services}) ->
    queryObject ||= {}

    # inject accountId into query
    if modelName is 'Account'
      queryObject.merge {_id: accountId}
    else
      queryObject.merge {accountId}

    services['model/findModel'] {queryObject, modelName}, done
