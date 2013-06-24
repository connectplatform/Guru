async = require 'async'
db = config.require 'load/mongo'
{Chat} = db.models

# Constructs the (inefficient) $where clause for our query
makeWhere = (age) ->
  # diffExpr = "#{Date.now()}"
  latestTimestampExpr = "this.history[this.history.length - 1].timestamp.getTime()"
  whereExpr = "Math.abs (#{Date.now()} - #{latestTimestampExpr}) >= #{age}"

module.exports = (done) ->
  # Find maximum time of last Chat activity in milliseconds
  maxAge = config.app.chats.minutesToTimeout * 60 * 1000
  isVacantCond = {status: 'Vacant'}
  isInactiveCond =
    '$and': [
      status: 'Waiting'
      $where: makeWhere maxAge
    ]
  cond = '$or': [isVacantCond, isInactiveCond]

  # Takes one chat and archives it
  archiveChat = (chat, next) ->
    chat.status = 'Archived'
    chat.save next

  Chat.find cond, (err, chats) ->
    # Archive all the found Chats which met our archival conditions
    async.each chats, archiveChat, done
