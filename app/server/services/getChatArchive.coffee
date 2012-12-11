{ChatHistory} = require('mongoose').models

module.exports =
  optional: ['search']
  required: ['accountId']
  service: ({accountId, search}, done) ->
    ChatHistory.find search.merge(accountId: accountId), done
