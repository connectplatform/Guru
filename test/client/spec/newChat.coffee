require ['spec/helpers/mock', 'spec/helpers/util'],
  (mock, {hasText, exists, delay}) ->

    describe 'New Chat', ->
      beforeEach ->
        run ->
          mock.services()
          window.location.hash = '/newChat'

        waitsFor hasText('.page-header h1', 'Welcome to live chat!'), 'New Chat did not load', 200

      it 'should display a prompt for a new chat', (done) ->
        expect($ '#newChat-form input#username').toExist()

      it 'should create a new chat', (done) ->
        $('#newChat-form input#username').val 'Bob'
        $('#newChat-form button[type=submit]').click()

        waitsFor exists('.chatPage input.message'), 'chat window did not load', 200
