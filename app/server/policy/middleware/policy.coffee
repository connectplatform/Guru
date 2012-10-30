module.exports =
  # list of rules
  [
    {
      filters: ['isOwner', 'setIsOnline' ]
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

        # these three are covered by isOwner
        'deleteModel'
        'findModel'
        'saveModel'
      ]
    }

    {
      filters:['sessionIsChatMember']
      only: [
        'getChatHistory'
        'inviteOperator'
        'getNonpresentOperators'
        'leaveChat'
        'printChat'
        'emailChat'
        'say'
      ]
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
      filters: ['isInvitedToChat']
      only: ['acceptInvite']
    }

    {
      filters: ['isInvitedToTransfer']
      only: ['acceptTransfer']
    }
  ]
