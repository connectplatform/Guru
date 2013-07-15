{getType} = config.require 'lib/util'
{ChatHistory} = require('mongoose').models

module.exports =
  optional: ['search']
  required: ['accountId', 'sessionSecret']
  service: ({accountId, search}, done) ->
    console.log '[getChatArchive]'.red, 1
    return done null, {archive: []} unless getType(search) is 'Object' and search.keys().length > 0
    console.log '[getChatArchive]'.red, 2
    ChatHistory.find search.merge(accountId: accountId), (err, archive) ->
      console.log '[getChatArchive]'.red, 3
      done err, {archive: archive}
