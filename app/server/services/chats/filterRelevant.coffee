getOperatorData = config.require 'services/operator/getOperatorData'

module.exports = (sessionId, chats, done) ->
  getOperatorData sessionId, (err, my) ->
    return done err if err

    isRelevant = (chat) ->
      return true if chat.relation?
      return true if my.role in ['Administrator', 'Supervisor']
      return false if chat.website not in my.websites
      return false if chat.department and chat.department.toLowerCase() not in my.specialties.map((s)-> s.toLowerCase())
      return true

    done null, chats.filter isRelevant
