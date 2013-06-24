async = require 'async'
db = config.require 'load/mongo'
{Chat} = db.models

# Constructs the (inefficient) $where clause for our query
makeWhere = (age) ->
  historyExistsExpr = "this.history.length"
  latestTimestampExpr = "this.history[this.history.length - 1].timestamp.getTime()"
  timeDiffExpr = "Math.abs (#{Date.now()} - #{latestTimestampExpr}"
  whereExpr = "#{historyExistsExpr} && (#{timeDiffExpr}) >= #{age})"

module.exports = (done) ->

  # Takes one chat and archives it
  archiveChat = (chat, next) ->
    chat.status = 'Archived'
    chat.save next
    
  # Find maximum time of last Chat activity in milliseconds
  maxAge = config.app.chats.minutesToTimeout * 60 * 1000
  
  Chat.find {'$where': makeWhere maxAge}, (err, chats) ->
    # Archive all the found Chats which met our archival conditions
    async.each chats, archiveChat, done
