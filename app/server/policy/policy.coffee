argumentValidations = require './argumentValidations'

policy =
  applyTo: /^[^\/]+$/ # only top level
  filterPrefix: 'filters'
  rules:
    [
      {
        filters: ['isOwner', 'setIsOnline']
        only: ['deleteModel', 'findModel', 'saveModel', 'awsUpload', 'getRecurlyToken']
      }

      {
        filters: ['isStaff', 'setIsOnline' ]
        except: [

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

policy.rules.unshift argumentValidations...

module.exports = policy
