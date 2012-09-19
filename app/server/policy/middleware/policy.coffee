{beforeFilter} = require './middlewareTools'
argumentValidations = require './argumentValidations'

module.exports = ->
  argumentValidations()
  beforeFilter ['isAdministrator'], only: ['deleteModel', 'findModel', 'saveModel', 'awsUpload']

  beforeFilter ['isStaff'],
    except: [
      'getMyRole',
      'login',
      'resetPassword',
      'forgotPassword',
      'newChat',
      'getExistingChatChannel',
      'visitorCanAccessChannel',
      'getChatHistory',

      # these three are covered by isAdministrator
      'deleteModel',
      'findModel',
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
