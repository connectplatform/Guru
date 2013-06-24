async = require 'async'
db = config.require 'load/mongo'
{Chat} = db.models

# Constructs the (inefficient) $where clause for our query
makeWhere = (age) ->
  diffExpr = "#{Date.now()} - "
  latestTimestampExpr = "this.history[this.history.length - 1].timestamp.getTime()"
  whereExpr = "#{diffExpr} - #{latestTimestampExpr} < #{age}"

module.exports = ->
  # Find maximum time of last Chat activity in milliseconds
  maxAge = config.chats.minutesToTimeout * 60 * 1000
  isVacantCond = {status: 'Vacant'}
  isInactiveCond =
    '$and': [
      status: 'Waiting'
      $where: makeWhere(maxAge)
    ]
  cond = '$or': [isVacantCond, isInactiveCond]

  # Takes one chat and archives it
  archiveChat = (chat, done) ->
    chat.status = 'Archived'
    chat.save done

  Chat.find cond, (err, chats) ->
    # Archive all the found Chats which met our archival conditions
    async.map chats, archiveChat, 
