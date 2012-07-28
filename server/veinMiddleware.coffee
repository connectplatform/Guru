redgoose = require 'redgoose'
async = require 'async'

isChatMember = require './validators/isChatMember'
isAdministrator = require './validators/isAdministrator'

{getType, tandoor} = require '../lib/util'

mapArgs = (arg) ->
  if (getType arg is '[object Object]') and arg.socket? and arg.name? and arg.listeners?
    return arg.name
  else
    return arg

routeValidators = {}

beforeFilter = (routes, validators) ->
  for route in routes
    routeValidators[route] ?= []
    routeValidators[route].push tandoor validator for validator in validators

noFilters = (routes) ->
  routeValidators[route] = [] for route in routes

middleware = (req, res, next) ->
  validators = routeValidators[req.service]
  return next 'Invalid service' unless validators?
  args = req.args.map mapArgs
  cookies = req.cookies

  packagedValidators = []
  packagedValidators.push validator args, cookies for validator in validators

  async.series packagedValidators, (err) ->
    next err

beforeFilter ['deleteUser', 'findUser', 'saveUser'], [isAdministrator]
beforeFilter ['getChatHistory'], [isChatMember]

# These routes should be universally accessible
noFilters [ 'getMyRole', 'login', 'newChat', 'getExistingChatChannel', 'visitorCanAccessChannel' ]

# These routes should have filters, but they have not been added yet
noFilters [
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

module.exports = middleware
