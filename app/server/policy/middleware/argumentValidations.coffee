module.exports =
  [
    {
      filters: ['cookieSessionExists']
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
      ]
    }

    {
      filters: ['argChatIdIsValid']
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
      filters: ['targetSessionIdIsValid']
      only: [ 'inviteOperator', 'transferChat']
    }

    {
      filters: ['argSessionIdIsValid']
      only: [ 'setSessionOffline']
    }

    {
      filters: ['modelNameIsValid']
      only: [ 'deleteModel', 'findModel', 'saveModel' ]
    }

    {
      filters: ['firstArgumentIsObject']
      only: [ 'findModel', 'saveModel', 'newChat', 'login', 'say' ]
    }

    {
      filters: ['loginObjectIsValid']
      only: ['login']
    }

    {
      filters: ['bothArgsAreStrings']
      only: ['changePassword']
    }

    {
      filters: ['objectChatIdIsValid', 'objectSessionIdIsValid', 'objectMessageExists' ]
      only: ['say']
    }
  ]
