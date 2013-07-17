{ChatSession} = config.require('load/mongo').models

module.exports = ({sessionId}, done) ->
  ChatSession.find {
    sessionId: sessionId
    relation: '$in': ['Invite', 'Transfer']
  }, (err, invites) ->
    done err, {invites}
