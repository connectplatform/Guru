define [], () ->
  manifest:
    myChats: true
      # accountId: true
      # status: true
      # history: [
      #   message: true
      #   timestamp: true
      #   username: true
      #   userId: true
      # ]
      # creationDate: true
      # websiteId: true
      # websiteUrl: true
      # specialtyId: true
      # acpData: true
    mySession: true
      # accountId: true
      # userId: true
      # username: true
      # online: true
      # secret: true
      # unansweredChats: true
      # unreadMessages: true
    myUser: true
      # accountId: true
      # sentEmail: false
      # registrationKey: false
      # email: true
      # password: false
      # role: true
      # websites: true
      # specialties: true
    visibleSessions: true
    visibleChats: true
    visibleChatSessions: true
      # sessionId: true
      # chatId: true
      # creationDate: true
      # relation: true
      # initiator: true

  payload: [
    root: 'myChats'
    timestamp: new Date
    data: []
   ,
    root: 'myChatSessions'
    timestamp: new Date
    data: []
   ,
    root: 'mySession'
    timestamp: new Date
    data: [
      id: '1111'
      accountId: '2222'
      userId: '3333'
      username: 'Graham'
      online: true
      secret: '4444'
      unansweredChats: 0
      unreadMessages: 0
    ]
   ,
    root: 'myUser'
    timestamp: new Date
    data: []
   ,
    root: 'visibleSessions'
    timestamp: new Date
    data: []
   ,
    root: 'visibleChats'
    timestamp: new Date
    data: []
   ,
    root: 'visibleChatSessions'
    timestamp: new Date
    data: []
  ]

  deltas: [
    [
      root: 'mySession'
      operation: 'set'
      id: '1111'
      path: 'unansweredChats'
      data: 1
    ]

    [
      root: 'mySession'
      operation: 'set'
      id: '1111'
      path: 'unansweredChats'
      data: 2
    ]

    [
      root: 'mySession'
      operation: 'set'
      id: '1111'
      path: 'unreadMessages'
      data: 1
    ]

    [
      root: 'mySession'
      operation: 'set'
      id: '1111'
      path: 'unreadMessages'
      data: 2
    ]

    [
      root: 'mySession'
      operation: 'set'
      id: '1111'
      path: 'unansweredChats'
      data: 3
    ]

    [
      root: 'mySession'
      operation: 'set'
      id: '1111'
      path: 'unansweredChats'
      data: 2
    ]

    [
      root: 'mySession'
      operation: 'set'
      id: '1111'
      path: 'username'
      data: 'Rosella'
    ]

    [
      root: 'mySession'
      operation: 'set'
      id: '1111'
      path: 'unreadMessages'
      data: 1
    ]
  ]