{beforeFilter} = require './middlewareTools'

module.exports = ->

  beforeFilter ['cookieSessionExists'],
    except: [
      'login',
      'getChatStats',
      'getExistingChatChannel',
      'getRoles',
      'login',
      'newChat',
      'getMyRole',
      'visitorCanAccessChannel'
    ]

  beforeFilter ['chatIdIsValid'],
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

  beforeFilter ['targetSessionIdIsValid'], only: [ 'inviteOperator', 'transferChat' ]

  beforeFilter ['modelNameIsValid'], only: [ 'deleteModel', 'findModel', 'saveModel' ]

  beforeFilter ['firstArgumentIsObject'], only: [ 'findModel', 'saveModel', 'newChat', 'login' ]

  beforeFilter ['loginObjectIsValid'], only: ['login']

  beforeFilter ['bothArgsAreStrings'], only: ['changePassword']
