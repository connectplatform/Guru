require ['spec/helpers/mock', 'spec/helpers/util', 'load/server'],
  (mock, {defaultTimeout, hasText, exists, delay}, server) ->

    describe 'New Chat', ->
      describe 'when username required', ->
        beforeEach ->
          runs ->
            mock.services()
            window.location.hash = '/newChat?websiteUrl=foo.com'

          waitsFor hasText('.page-header h1', 'Welcome to live chat!'), 'New Chat did not load', defaultTimeout

        it 'should display a form for a new chat', (done) ->
          runs ->
            expect($ '#newChat input[name=username]').toExist()

        it 'submitting form should create a new chat', (done) ->
          runs ->
            mock.returnChat()
            $('#newChat input[name=username]').val 'Bob'
            $('#newChat button[type=submit]').click()

          waitsFor exists('.chatPage textarea.message'), 'chat window did not load', defaultTimeout

      describe 'when no params needed', ->
        it 'should redirect to chat', (done) ->
          runs ->
            mock.services()
            mock.returnChat()
            window.location.hash = '/newChat?websiteUrl=foo.com'

          waitsFor exists('.chatPage textarea.message'), 'chat window did not load', defaultTimeout

      describe 'when no operators exist', ->
        it 'should redirect to email', (done) ->
          runs ->
            mock.services()
            mock.noOperators()
            window.location.hash = '/newChat?websiteUrl=bar.com'

          waitsFor exists('input[name=subject]'), 'email window did not load', defaultTimeout
