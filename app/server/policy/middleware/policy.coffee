{beforeFilter} = require './middlewareTools'
argumentValidations = require './argumentValidations'

module.exports = ->
  argumentValidations()
  beforeFilter ['isAdministrator', 'setIsOnline' ], only: ['deleteModel', 'findModel', 'saveModel', 'awsUpload']

  beforeFilter ['isStaff', 'setIsOnline' ],
    except: [
      'getMyRole',
      'login',
      'resetPassword',
      'forgotPassword',
      'newChat',
      'getExistingChat',
      'createChatOrGetForm',
      'visitorCanAccessChannel',
      'getChatHistory',
      'getLogoForChat',
      'setSessionOffline',
      'say',
      'kickUser',

      # these three are covered by isAdministrator
      'deleteModel',
      'findModel',
      'saveModel',
    ]

  beforeFilter ['argIsChatMember'],
    only: [
      'getChatHistory',
      'inviteOperator',
      'getNonpresentOperators',
      'leaveChat'
    ]

  beforeFilter ['objIsChatMember'], only: [ 'say' ]

  beforeFilter ['isVisibleInChat'], only: [ 'transferChat', 'kickUser']
  beforeFilter ['isNotVisibleChatMember'], only: ['acceptChat', 'acceptInvite', 'acceptTransfer', 'joinChat']
  beforeFilter ['isNotChatMember'], only: ['watchChat']
  beforeFilter ['isInvitedToChat'], only: ['acceptInvite']
  beforeFilter ['isInvitedToTransfer'], only: ['acceptTransfer']
