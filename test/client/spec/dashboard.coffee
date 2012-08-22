require ['spec/helpers/mock', 'spec/helpers/util', 'app/pulsar'], (mock, {hasText, exists}, pulsar) ->

  sendInvite = ->
    pulsar.channel('notify:session:session_foo').emit 'newInvites', {chatId: 'chat_3', type: 'invite'}

  describe 'Dashboard', ->
    beforeEach ->
      mock.services()
      mock.loggedIn()
      pulsar.channel('notify:session:session_foo')

      window.location.hash = '/dashboard'
      mock.renderSidebar()
      waitsFor hasText('#dashboard h1', 'Dashboard'), 'dashboard to load', 200

    it 'should refresh when an invite is received', ->

      hasChats = ->
        numChats = $('#dashboard table tr').length - 1
        return numChats > 1

      expect(hasChats()).toBeFalsy()

      # mock chats and send notification
      mock.activeChats()
      sendInvite()

      # should see chats
      waitsFor hasChats, 'dashboard to refresh', 200

    it 'should show a badge on the sidebar', ->

      expect($ '#sidebar .notifyInvites .badge').not.toExist()

      # mock chats and send notification
      mock.activeChats()
      sendInvite()

      # should see invite badge in sidebar
      waitsFor exists('#sidebar .notifyInvites .badge'), 'invite badge in sidebar', 200
