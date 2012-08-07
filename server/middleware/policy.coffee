{beforeFilter} = require './middlewareTools'

module.exports = ->
  beforeFilter ['isAdministrator'], only: ['deleteUser', 'findUser', 'saveUser']
  beforeFilter ['isChatMember'], only: ['getChatHistory', 'inviteOperator']

  beforeFilter ['isRegisteredUser'],
    except: [
      'getMyRole',
      'login',
      'newChat',
      'getExistingChatChannel',
      'visitorCanAccessChannel',
      'getChatHistory',
      'deleteUser',#these three are covered by isAdministrator
      'findUser',
      'saveUser'
    ]

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
