{beforeFilter} = require './middlewareTools'

module.exports = ->

  beforeFilter ['cookieSessionExists'],
    except: [
      'login',
      'getChatStats',
      'getExistingChat',
      'getRoles',
      'resetPassword',
      'forgotPassword',
      'newChat',
      'getMyRole',
      'visitorCanAccessChannel'
    ]

  beforeFilter ['argChatIdIsValid'],
    only: [
      'acceptChat',
      'acceptInvite',
      'acceptTransfer',
      'getChatHistory',
      'getNonpresentOperators',
      'inviteOperator',
      'joinChat',
      'kickUser',
      'leaveChat',
      'transferChat',
      'visitorCanAccessChannel',
      'watchChat'
    ]

  beforeFilter ['targetSessionIdIsValid'], only: [ 'inviteOperator', 'transferChat']
  beforeFilter ['argSessionIdIsValid'], only: [ 'setSessionOffline']

  beforeFilter ['modelNameIsValid'], only: [ 'deleteModel', 'findModel', 'saveModel' ]

  beforeFilter ['firstArgumentIsObject'], only: [ 'findModel', 'saveModel', 'newChat', 'login', 'say' ]

  beforeFilter ['loginObjectIsValid'], only: ['login']

  beforeFilter ['bothArgsAreStrings'], only: ['changePassword']

  beforeFilter ['objectChatIdIsValid', 'objectSessionIdIsValid', 'objectMessageExists' ], only: ['say']
