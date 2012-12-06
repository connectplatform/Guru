getOperatorData = config.require 'services/operator/getOperatorData'
enums = config.require 'load/enums'
{Specialty} = require('mongoose').models

module.exports = (accountId, sessionId, chats, done) ->
  return done null, [] unless chats and chats.length > 0

  getOperatorData accountId, sessionId, (err, my) ->
    return done err if err

    # Ball of Mud architecture
    Specialty.find {accountId: accountId, name: $in: chats.map('department')}, {_id: true, name: true}, (err, results) ->
      specMap = {}
      for r in results
        specMap[r.name] = r._id

      for c in chats
        c.department = specMap[c.department]

      isRelevant = (chat) ->
        return true if chat.relation?
        return true if my.role in enums.managerRoles
        return false if chat.websiteId not in my.websites
        return false if chat.department and (chat.department not in my.specialties)
        return true

      done null, chats.filter isRelevant
