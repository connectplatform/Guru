{beforeFilter} = require './middlewareTools'

module.exports = ->
  beforeFilter ['isAdministrator'], only: ['deleteUser', 'findUser', 'saveUser']

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

  beforeFilter ['isChatMember'],
    only: [
      'getChatHistory',
      'inviteOperator',
      'getNonpresentOperators',
      'leaveChat'
    ]

  beforeFilter ['isVisibleInChat'], only: [ 'transferChat', 'kickUser']
  beforeFilter ['isNotVisibleChatMember'], only: ['acceptChat', 'acceptInvite', 'acceptTransfer', 'joinChat']
  beforeFilter ['isNotChatMember'], only: ['watchChat']
  #beforeFilter ['isInvitedToChat'], only: ['acceptInvite']
  #beforeFilter ['isInvitedToTransfer'], only: ['acceptTransfer']
###
# These routes should have filters, but they have not been added yet
[
  'getChatStats',
  'readChats',
]
