module.exports =
  [
    {
      filters: ['isAdministrator', 'setIsOnline' ]
      only: ['deleteModel', 'findModel', 'saveModel', 'awsUpload']
    }

    {
      filters: ['isStaff', 'setIsOnline' ]
      except: [

        # used by everyone
        'getMyRole'
        'getChatHistory'
        'getLogoForChat'
        'setSessionOffline'
        'say'
        'leaveChat'
        'printChat'
        'emailChat'

        # visitor
        'newChat'
        'getExistingChat'
        'createChatOrGetForm'
        'visitorCanAccessChannel'

        # operator
        'login'
        'resetPassword'
        'submitQuestion'
        'forgotPassword'

        # account creation
        'createAccount'

        # these three are covered by isAdministrator
        'deleteModel'
        'findModel'
        'saveModel'
      ]
    }

    {
      filters:['argIsChatMember']
      only: [
        'getChatHistory'
        'inviteOperator'
        'getNonpresentOperators'
        'leaveChat'
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
