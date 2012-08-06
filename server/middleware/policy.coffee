{beforeFilter} = require './middlewareTools'

module.exports = ->
  beforeFilter ['isAdministrator'], only: ['deleteUser', 'findUser', 'saveUser']
  beforeFilter ['isChatMember'], only: ['getChatHistory']
###
# These routes should have filters, but they have not been added yet
[
  'acceptChat',
  'acceptInvite',
  'acceptTransfer',
  'getActiveChats',
  'getChatStats',
  'getMyChats',
  'getNonpresentOperators',
  'getRoles',
  'joinChat',
  'kickUser',
  'leaveChat',
  'readChats',
  'transferChat',
  'watchChat'
]
