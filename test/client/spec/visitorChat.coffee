require ['spec/helpers/mock', 'spec/helpers/util', 'load/pulsar', 'load/server'],
  (mock, {defaultTimeout, hasText, exists}, pulsar, server) ->

    describe 'Visitor Chat', ->
      beforeEach ->

        # run through the chat creation process
        runs ->
          mock.services()
          mock.visitor()
          window.location.hash = '/newChat'

        waitsFor exists('#newChat'), 'New Chat did not load', defaultTimeout

        runs ->
          # given proper params, server returns a chatId
          mock.returnChat()
          $('#username').val 'aVisitor'
          $('#newChat button.btn-primary').click()

        waitsFor exists('.chat-display-box'), 'Visitor chat did not load', defaultTimeout

      afterEach ->
        runs ->
          window.location.hash = '/test'
          mock.loggedOut()

      it 'should display a welcome message', ->
        waitsFor hasText('.chat-display-box p', "Welcome to live chat!  An operator will be with you shortly."), defaultTimeout, 'Welcome message did not display'

      it 'should receive and display messages', ->
        pulsar.channel("chat_foo").emit 'serverMessage', {username: "Helper Dude", message: "How can I help?", timestamp: 1}

                                          # this crazy selector gets the second p tag
        waitsFor hasText(".chat-display-box p:visible+p", 'Helper Dude: How can I help?'), 'Message sent did not display', defaultTimeout

        expect( $(".chat-display-box p:visible").length).toEqual 2

      it 'should give the visitor a button to leave the chat', ->
        waitsFor exists('.leaveButton'), 'Visitor chat did not load', defaultTimeout

        runs ->
          userLeft = false
          server.leaveChat = (args..., cb) ->
            userLeft = true
            cb null, null

          $('.leaveButton').click()
          didLeave = -> userLeft
          waitsFor didLeave, defaultTimeout, 'leaveChat was not called'

        messageDisplayed = ->
          $('.chat-display-box').children().eq(1)?.text() is 'You have left the chat.'

        waitsFor messageDisplayed, 500, 'Exit message did not display'

      it 'should give the user a button to print in a new window', ->
        waitsFor exists('.printButton'), 'could not find print button', defaultTimeout

        opened = false

        runs ->
          window.open = (location) ->
            expect location, "https://localhost:4003/#/chat_foo"
            opened = true

          $('.printButton').click()

        waitsFor -> opened
