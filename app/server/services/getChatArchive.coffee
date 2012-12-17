{ChatHistory} = require('mongoose').models

module.exports =
  optional: ['search']
  required: ['accountId']
  service: ({accountId, search}, done) ->
    return done null, [] unless search and typeof(search) is 'object' and Object.keys(search).length > 0
    ChatHistory.find search.merge(accountId: accountId), done
