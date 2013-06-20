module.exports =
  creationEvent: (collection, record) ->
    return {
      timestamp: new Date
      namespace: "#{config.mongo.dbName}.#{collection}"
      oplist: [
        operation: 'set'
        id: record._id
        path: '.'
        data: record
      ]
    }

  removalEvent: (collection, record) ->
    return {
      timestamp: new Date
      namespace: "#{config.mongo.dbName}.#{collection}"
      oplist: [
        operation: 'unset'
        id: record._id
        path: '.'
      ]
    }
