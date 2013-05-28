policy =
  applyTo: /^[^\/]+$/ # only top level
  filterPrefix: 'filters'
  rules:
    [
      {
        filters: ['enforceServiceSignature']
        except: []
      }

      # {
      #   filters: ['lookupAccountId']
      #   except: [

      #     # everyone
      #     'getMyRole'
      #     'log'
      #     'getHeaderFooter'
      #     'getImageUrl'

      #     # visitor
      #     'newChat'
      #     'submitQuestion'
      #     'getExistingChat'
      #     'createChatOrGetForm'
      #     'visitorCanAccessChannel'

      #     # operator
      #     'login'
      #     'resetPassword'
      #     'forgotPassword'

      #     # account creation
      #     'createAccount'
      #     'inviteOperator'
      #     'transferChat'
      #     'setSessionOffline'
      #   ]
      # }

      {
        filters: ['objectMessageExists' ]
        only: ['say']
      }

      {
        filters: ['isOwner', 'setIsOnline']
        only: ['deleteModel', 'findModel', 'saveModel', 'awsUpload', 'getRecurlyToken']
      }

      {
        filters: ['isStaff', 'setIsOnline' ]
        except: [
          # testing
          # 'acceptChat' # FIX THIS, THANKS

          # used by everyone
          'getMyRole'
          'getChatHistory'
          'getLogoForChat'
          'getImageUrl'
          'setSessionOffline'
          'say'
          'leaveChat'
          'printChat'
          'emailChat'
          'log'
          'getHeaderFooter'

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
          'getRecurlyToken'
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
        filters: ['isNotVisibleChatMember', 'accountInGoodStanding']
        only: ['acceptChat', 'acceptInvite', 'acceptTransfer', 'joinChat']
      }

      {
        filters: ['isNotChatMember', 'accountInGoodStanding']
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

module.exports = policy
