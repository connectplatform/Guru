require ['spec/helpers/mock', 'spec/helpers/util'],
  (mock, {hasText, exists, delay}) ->

    describe 'New Chat', ->
      beforeEach ->
        window.location.hash = '/newChat'
        waitsFor hasText('.page-header h1', 'Welcome to live chat!'), 'New Chat did not load', 200

      it 'should display a prompt for a new chat', (done) ->
        expect($ '#newChat-form input#username').exists()
