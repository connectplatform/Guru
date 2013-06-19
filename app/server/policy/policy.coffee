policy =
  applyTo: /^[^\/]+$/ # only top level
  filterPrefix: 'filters'
  rules:
    [
      {
        filters: ['enforceServiceSignature']
        except: []
      }


      {
        filters: ['sessionIdMatchesSecret']
        only: [
          'chats/getRelationToChat'
          'acceptInvite'
          'acceptTransfer'
          'changePassword'
          'getActiveChats'
          'getChatStats'
          'getExistingChat'
          'getMyChats'
          'getNonpresentOperators'
          'inviteOperator'
          'joinChat'
          'leaveChat'
          'setSessionOffline'
          'session/setSessionOnlineStatus'
          'operator/getChatMembership'
          'logout'
        ]
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
          'getNonpresentOperators'
          'leaveChat'
          'printChat'
          'emailChat'
        ]
      }

      # Right now, we only want to send invites or transfers if an Operator
      # is actually a Member of the chat. Since `getNonpresentOperators`
      # is only used for these two activities, right now we should employ
      # the stricter filter (`sessionIsChatMember`)
      # {
      #   filters:['sessionIsChatMemberOrWatching']
      #   only: [
      #     'getNonpresentOperators'
      #     'getChatHistory' # ???
      #   ]
      # }

      {
        filters: ['isVisibleInChat']
        only: ['say', 'inviteOperator', 'transferChat', 'kickUser']
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
