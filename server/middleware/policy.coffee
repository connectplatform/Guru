{beforeFilter} = require './middlewareTools'

module.exports = ->
  beforeFilter ['isAdministrator'], only: ['deleteUser', 'findUser', 'saveUser']
  beforeFilter ['isChatMember'],
    only: [
      'getChatHistory',
      'inviteOperator',
      'transferChat',
      'getNonpresentOperators',
      'kickUser',
      'leaveChat'
    ]

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
  'getRoles',
  'joinChat',
  'leaveChat',
  'readChats',
  'watchChat'
]
