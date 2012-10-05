require ['spec/helpers/mock', 'spec/helpers/util', 'load/pulsar', 'load/server'],
  (mock, {hasText, exists}, pulsar, server) ->

    describe 'Visitor Chat', ->
      beforeEach ->
        mock.services()
        mock.visitor()
        window.location.hash = '/test'

      afterEach ->
        window.location.hash = '/test'
        mock.loggedOut()

      it 'should call printChat and print the page', ->
        runs ->
          wasPrinted = false
          windowWasPrinted = -> wasPrinted
          window.print = -> wasPrinted = true

          window.location.hash = '/printChat/some_chat_id'

          waitsFor windowWasPrinted
          runs ->
