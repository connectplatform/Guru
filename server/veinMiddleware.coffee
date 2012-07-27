redgoose = require 'redgoose'

chatMember = require './validators/chatMember'

globalServices = [
  'getMyRole',
  'login',
  'signup',
  'newChat',
  '',
  'getExistingChatChannel',
  'visitorCanAccessChannel'
]

availibleToChatMembers = [
  'getChatHistory'
]

module.exports = (req, res, next) ->

  #TODO figure out way to make control flow nice here
  return next() if req.service in globalServices

  if req.service in availibleToChatMembers
    chatMember req, (isAllowed) ->
      if isAllowed
        next()
      else
        next 'not authorized'

  else
    userSession = unescape res.cookie 'session'
    {Session} = redgoose.models
    Session.get(userSession).role.get (err, role) ->
      console.log 'Auth middleware error:', err if err?
      if (role is 'Operator') or (role is 'Administrator')
        next()
      else
        res.cookie 'session', null
        res.send "#{req.service} not authorized"
        next()
