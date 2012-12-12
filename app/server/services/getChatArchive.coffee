{ChatHistory} = require('mongoose').models

module.exports =
  optional: ['search']
  required: ['accountId']
  service: ({accountId, search}, done) ->
    search ||= {}
    ChatHistory.find search.merge(accountId: accountId), done
