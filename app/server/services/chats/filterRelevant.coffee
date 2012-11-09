getOperatorData = config.require 'services/operator/getOperatorData'
enums = config.require 'load/enums'

module.exports = (accountId, sessionId, chats, done) ->
  getOperatorData accountId, sessionId, (err, my) ->
    return done err if err

    isRelevant = (chat) ->
      return true if chat.relation?
      return true if my.role in enums.managerRoles
      return false if chat.websiteId not in my.websites
      return false if chat.department and (chat.department.toLowerCase() not in my.specialties.map((s)-> s.toLowerCase()))
      return true

    done null, chats.filter isRelevant
