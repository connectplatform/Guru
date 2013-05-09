# stoic = require 'stoic'
# {Session} = stoic.models

db = config.require 'load/mongo'
{User} = db.models

module.exports = (accountId, sessionId, done) ->
  Session(accountId).get(sessionId).operatorId.get (err, opId) ->
    User.findById opId, done
