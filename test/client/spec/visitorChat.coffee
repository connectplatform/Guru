require ['spec/helpers/mock', 'spec/helpers/util', 'load/pulsar', 'load/server'],
  (mock, {hasText, exists}, pulsar, server) ->

    describe 'Visitor Chat', ->
      beforeEach ->
        mock.services()
        mock.visitor()
        window.location.hash = '/newChat'
        waitsFor exists('#newChat-form'), 'New Chat did not load', 200

        runs ->
          $('#username').val 'aVisitor'
          $('.newChatButton').click()

          waitsFor exists('.chat-display-box'), 'Visitor chat did not load', 200
          runs ->

      afterEach ->
        window.location.hash = '/test'
        mock.loggedOut()

      it 'should display a welcome message', ->
        runs ->

          waitsFor hasText('.chat-display-box p', "Welcome to live chat!  An operator will be with you shortly."), 200, 'Welcome message did not display'
          runs ->

      it 'should give the visitor a button to leave the chat', ->
        runs ->
          waitsFor exists('.leaveButton'), 'Visitor chat did not load', 200
          runs ->

            userKicked = false
            server.kickUser = (args..., cb) ->
              userKicked = true

            $('.leaveButton').click()
            wasKicked = -> userKicked
            waitsFor wasKicked

            messageDisplayed = ->
              $('.chat-display-box').children().eq(1)?.text() is 'You have left the chat.'

            waitsFor messageDisplayed, 200, 'Exit message did not display'
            runs ->

      it 'should give the user a button to print in a new window', ->
        runs ->
          waitsFor exists('.printButton'), 'Visitor chat did not load', 200
          runs ->

          opened = false
          windowOpened = -> opened
          window.open = (location) ->
            expect location, "https://localhost:4000/#/foo"
            opened = true

          $('.printButton').click()
          waitsFor windowOpened
          runs ->

