{getType} = config.require 'lib/util'
{ChatHistory} = require('mongoose').models

module.exports =
  optional: ['search']
  required: ['accountId']
  service: ({accountId, search}, done) ->
    return done null, {archive: []} unless getType(search) is 'Object' and search.keys().length > 0
    ChatHistory.find search.merge(accountId: accountId), (err, archive) ->
      done err, {archive: archive}
