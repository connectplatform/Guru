module.exports =
  [
    {
      filters: ['enforceServiceSignature', 'lookupAccountId']
      except: []
    }

    {
      filters: ['sessionIdIsValid']
      except: [

        # everyone
        'getMyRole'
        'log'
        'getHeaderFooter'
        'getImageUrl'

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
      filters: ['chatIdIsValid', 'sessionIdIsValid', 'objectMessageExists' ]
      only: ['say']
    }
  ]
