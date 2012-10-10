module.exports =
  [
    {
      filters: ['isAdministrator', 'setIsOnline' ]
      only: ['deleteModel', 'findModel', 'saveModel', 'awsUpload']
    }

    {
      filters: ['isStaff', 'setIsOnline' ]
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
        'printChat',
        'emailChat',

        # these three are covered by isAdministrator
        'deleteModel',
        'findModel',
        'saveModel',
      ]
    }

    {
      filters:['argIsChatMember']
      only: [
        'getChatHistory',
        'inviteOperator',
        'getNonpresentOperators',
        'leaveChat',
        'printChat'
      ]
    }

    {
      filters: ['objIsChatMember']
      only: [ 'say' ]
    }

    {
      filters: ['isVisibleInChat']
      only: [ 'transferChat', 'kickUser']
    }

    {
      filters: ['isNotVisibleChatMember']
      only: ['acceptChat', 'acceptInvite', 'acceptTransfer', 'joinChat']
    }

    {
      filters: ['isNotChatMember']
      only: ['watchChat']
    }

    {
      filters: ['isChatMember']
      only: ['emailChat']
    }

    {
      filters: ['isInvitedToChat']
      only: ['acceptInvite']
    }

    {
      filters: ['isInvitedToTransfer']
      only: ['acceptTransfer']
    }
  ]
