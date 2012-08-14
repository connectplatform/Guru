require ['spec/helpers/mock', 'spec/helpers/util'], (mock, {exists}) ->

  describe 'Operator Chat', ->
    beforeEach ->
      mock.services()
      mock.loggedIn()
      window.location.hash = '/operatorChat'
      console.log 'before operatorChat'

      waitsFor exists('#chatTabs'), 'Operator Chats did not load', 1000

    afterEach ->
      mock.loggedOut()
      console.log 'after operatorChat'

    it 'should show the chat page', ->
      expect($ '#chatTabs').toExist()

