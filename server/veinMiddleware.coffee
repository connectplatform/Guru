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
async = require 'async'
routeValidators = {}

beforeFilter = (routes, validators) ->
  for route in routes
    routeValidators[route] ?= []
    routeValidators[route].push validator for validator in validators

noFilters = (routes) ->
  routeValidators[route] = [] for route in routes

middleware = (req, res, next) ->
  validators = routeValidators[req.service]
  return next 'Invalid service' unless validators?
  async.series (validator req for validator in validators), (err) ->
    next err

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

{getType} = require '../lib/util'
mapArgs = (arg) ->
  if (getType arg is '[object Object]') and arg.socket? and arg.name? and arg.listeners?
    return arg.name
  else
    return arg

module.exports = (req, res, next) ->

  args = req.args.map mapArgs
  cookies = req.cookies

  return next() if req.service in globalServices

  if req.service in availibleToChatMembers
    isChatMember args, cookies, (err) ->
      next err

  else if req.service in administratorOnly
    isAdministrator args, cookies, (isAllowed) ->
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
