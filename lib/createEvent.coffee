module.exports = (record) ->
  return {
    timestamp: new Date
    namespace: "#{config.mongo.dbName}.chats"
    oplist: [
      operation: 'set'
      id: record._id
      path: '.'
      data: record
    ]
  }
