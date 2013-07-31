define [], () ->
  manifest:
    myData:
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
      # myUser: true
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

  payload:
    root: 'myData'
    timestamp: new Date
    data: [
      myChats: []
      myChatSessions: []
      mySession:
        id: '1111'
        accountId: '2222'
        userId: '3333'
        username: 'Graham'
        online: true
        secret: '4444'
        unansweredChats: 0
        unreadMessages: 0
      visibleSessions: []
      visibleChatSessions: []
    ]

  deltas: [
    [
      root: 'myData.mySession'
      operation: 'set'
      id: '1111'
      path: 'unansweredChats'
      data: 1
    ]

    [
      root: 'myData.mySession'
      operation: 'set'
      id: '1111'
      path: 'unansweredChats'
      data: 2
    ]

    [
      root: 'myData.mySession'
      operation: 'set'
      id: '1111'
      path: 'unreadMessages'
      data: 1
    ]

    [
      root: 'myData.mySession'
      operation: 'set'
      id: '1111'
      path: 'unreadMessages'
      data: 2
    ]

    [
      root: 'myData.mySession'
      operation: 'set'
      id: '1111'
      path: 'unansweredChats'
      data: 3
    ]

    [
      root: 'myData.mySession'
      operation: 'set'
      id: '1111'
      path: 'unansweredChats'
      data: 2
    ]

    [
      root: 'myData.mySession'
      operation: 'set'
      id: '1111'
      path: 'username'
      data: 'Rosella'
    ]

    [
      root: 'myData.mySession'
      operation: 'set'
      id: '1111'
      path: 'unreadMessages'
      data: 1
    ]
  ]