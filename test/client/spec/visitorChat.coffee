require ['spec/helpers/mock', 'spec/helpers/util', 'load/pulsar'],
  (mock, {hasText, exists, delay}, pulsar) ->

    describe 'Visitor Chat', ->
      beforeEach ->
        mock.services()
        mock.visitor()
        window.location.hash = '/newChat'
        waitsFor exists('#newChat-form'), 'New Chat did not load', 200
        $('#username').val 'aVisitor'
        $('#newChat-form').submit()
        delay 100
        pageExists = $('.chat-display-box').length > 0
        expect pageExists, 'Visitor Chat page did not load'

      afterEach ->
        mock.loggedOut()

      it 'should display a welcome message', ->
        messageExists = hasText('.chat-display-box', 'An operator will be with you shortly')
        expect messageExists, 'Welcome message did not display'

