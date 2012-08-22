require ['spec/helpers/mock', 'spec/helpers/util', 'app/pulsar'], (mock, {hasText, exists}, pulsar) ->

  describe 'Dashboard', ->
    beforeEach ->
      mock.services()
      mock.loggedIn()
      pulsar.channel('notify:session:session_foo')

      window.location.hash = '/dashboard'
      waitsFor hasText('#dashboard h1', 'Dashboard'), 'Did not see dashboard', 200

    it 'should refresh when an invite is received', ->

      hasChats = ->
        numChats = $('#dashboard table tr').length - 1
        return numChats > 1

      # should not see chats
      expect(hasChats()).toBeFalsy()

      # mock chats
      mock.activeChats()

      # send notification
      pulsar.channel('notify:session:session_foo').emit 'invite', 'chat_3'

      # should see chats
      waitsFor hasChats, 'Dashboard did not refresh', 200

