module.exports =
  [
    {
      filters: ['enforceServiceSignature']
      except: []
    }

    {
      filters: ['lookupAccountId']
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
      filters: ['objectMessageExists' ]
      only: ['say']
    }
  ]
