{beforeFilter} = require './middlewareTools'

module.exports = ->
  beforeFilter ['isAdministrator'], only: ['deleteUser', 'findUser', 'saveModel']

  beforeFilter ['isStaff'],
    except: [
      'getMyRole',
      'login',
      'newChat',
      'getExistingChatChannel',
      'visitorCanAccessChannel',
      'getChatHistory',
      'deleteUser',#these three are covered by isAdministrator
      'findUser',
      'saveModel'
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
  beforeFilter ['isInvitedToChat'], only: ['acceptInvite']
  beforeFilter ['isInvitedToTransfer'], only: ['acceptTransfer']
