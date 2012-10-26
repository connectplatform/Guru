module.exports =
  [
    {
      filters: ['enforceServiceSignature']
      except: []
    }

    {
      filters: ['sessionIdIsValid']
      except: [

        # should these be here?
        'getRoles'
        'getChatStats'

        # everyone
        'getMyRole'

        # visitor
        'newChat'
        'submitQuestion'
        'getExistingChat'
        'createChatOrGetForm'
        'visitorCanAccessChannel'

        # operator
        'login'
        'resetPassword'
        'forgotPassword'

        # account creation
        'createAccount'
        'inviteOperator'
        'transferChat'
        'setSessionOffline'
      ]
    }

    {
      filters: ['chatIdIsValid']
      only: [
        'acceptChat'
        'acceptInvite'
        'acceptTransfer'
        'emailChat'
        'getChatHistory'
        'getNonpresentOperators'
        'inviteOperator'
        'joinChat'
        'kickUser'
        'leaveChat'
        'printChat'
        'transferChat'
        'visitorCanAccessChannel'
        'watchChat'
      ]
    }

    {
      filters: ['modelNameIsValid']
      only: [ 'deleteModel', 'findModel', 'saveModel' ]
    }

    {
      filters: ['chatIdIsValid', 'sessionIdIsValid', 'objectMessageExists' ]
      only: ['say']
    }
  ]
