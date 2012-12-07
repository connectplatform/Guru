getOperatorData = config.require 'services/operator/getOperatorData'
enums = config.require 'load/enums'
{Specialty} = require('mongoose').models

module.exports = (accountId, sessionId, chats, done) ->
  return done null, [] unless chats and chats.length > 0

  getOperatorData accountId, sessionId, (err, my) ->
    return done err if err

    #console.log 'comparing:', chats, 'to:', my.specialties
    isRelevant = (chat) ->
      return true if chat.relation?
      return true if my.role in enums.managerRoles
      return false if chat.websiteId not in my.websites
      return false if chat.department and (chat.department not in my.specialties)
      return true

    done null, chats.filter isRelevant
