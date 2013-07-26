require.config
  baseUrl: '.'
  packages: [
    {name: 'app', location: 'js'}
    {name: 'templates', location: 'templates'}
    {name: 'load', location: 'js/load'}
    {name: 'helpers', location: 'js/helpers'}
    {name: 'routes', location: 'js/routes'}
    {name: 'vendor', location: 'js/vendor'}
    {name: 'policy', location: 'js/policy'}
    {name: 'middleware', location: 'js/policy/middleware'}
    {name: 'components', location: 'components'}
  ]

  map: '*':
    {'flight/component': 'js/vendor/flight/lib/component'}

require [
  'components/navBar'
  'vendor/particle'
  'vendor/eventemitter2'
],
(navBar, particle, EventEmitter2) ->

  mockStream = (oplist) ->
    (identity, receive, finish) ->
      manifest =
        myData:
          chatSessions: true
            # sessionId: true
            # chatId: true
            # creationDate: true
            # relation: true
            # initiator: true
          session: true
            # accountId: true
            # userId: true
            # username: true
            # online: true
            # secret: true
            # unansweredChats: true
            # unreadMessages: true
      receive 'manifest', manifest

      payload =
        root: 'myData'
        timestamp: new Date
        data: [
          'chatSessions':
            id: 2
            sessionId: '1111'
            chatId: '4321'
            creationDate: new Date
            relation: 'Member'
            initiator: '666'
          'session':
            id: '1111'
            accountId: '2222'
            userId: '3333'
            username: 'Graham'
            online: true
            secret: '4444'
            unansweredChats: 0
            unreadMessages: 0
        ]
      receive 'payload', payload

      if oplist
        receive 'delta', {
          root: 'myData'
          timestamp: new Date
          oplist: oplist
        }

      finish()

  oplist = [
    root: 'myData.session'
    operation: 'set'
    id: '1111'
    path: 'unansweredChats'
    data: 1
  ]
  
  collector = new particle.Collector
    identity:
      sessionId: '1111'
    onRegister: mockStream oplist

  navBar.attachTo '#navBar', {
    role: 'Operator'
    appName: 'Guru'
    collector: collector
  }
