getOperatorData = config.require 'services/operator/getOperatorData'
enums = config.require 'load/enums'
{Specialty} = require('mongoose').models

module.exports = (accountId, sessionId, chats, done) ->
  return done null, [] unless chats and chats.length > 0

  getOperatorData accountId, sessionId, (err, my) ->
    return done err if err
    return done null, [] if not my

    #console.log 'comparing:', chats, 'to:', my.specialties
    isRelevant = (chat) ->
      unless chat
        config.warn new Error 'Tried to filter a chat that does not exist.'
        return false

      return true if chat.relation?
      return true if my.role in enums.managerRoles
      return false if chat.websiteId not in my.websites
      return false if chat.specialtyId and (chat.specialtyId not in my.specialties)
      return true

    done null, chats.filter isRelevant
