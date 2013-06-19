{tandoor} = config.require 'load/util'
{ChatSession} = config.require('load/mongo').models

module.exports = tandoor (sessionId, done) ->
  ChatSession.find {
    sessionId: sessionId
    relation: '$in': ['Invite', 'Transfer']
  }, done
