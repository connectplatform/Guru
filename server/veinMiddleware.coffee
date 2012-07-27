redgoose = require 'redgoose'

isChatMember = require './validators/isChatMember'
isAdministrator = require './validators/isAdministrator'

globalServices = [
  'getMyRole',
  'login',
  'newChat',
  'getExistingChatChannel',
  'visitorCanAccessChannel'
]

###
{tandoor} = require '../lib/util'
async = require 'async'
routeValidators = {}

beforeFilter = (routes, validators) ->
  for route in routes
    routeValidators[route] ?= []
    routeValidators[route].push validator for validator in validators

noFilters = (routes) ->
  routeValidators[route] = [] for route in routes

middleware = (req, res, next) ->
  service = req.service
  return next 'Invalid service' unless service?
  async.series ro


beforeFilter ['deleteUser', 'findUser', 'saveUser'], [isAdministrator]
###

availibleToChatMembers = [
  'getChatHistory'
]

administratorOnly = [
  'deleteUser',
  'findUser',
  'saveUser'
]

unsortedServices = [
  'acceptChat',
  'acceptInvite',
  'acceptTransfer',
  'getActiveChats',
  'getChatStats',
  'getMyChats',
  'getNonpresentOperators',
  'getRoles',
  'inviteOperator',
  'joinChat',
  'kickUser',
  'leaveChat',
  'readChats',
  'transferChat',
  'watchChat'
]

module.exports = (req, res, next) ->

  #TODO figure out way to make control flow nice here
  return next() if req.service in globalServices

  if req.service in availibleToChatMembers
    isChatMember req, (err) ->
      next err

  else if req.service in administratorOnly
    isAdministrator req, (isAllowed) ->
      if isAllowed
        next()
      else
        next 'not authorized'

  else
    return next 'not authorized' unless req.service in unsortedServices
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
