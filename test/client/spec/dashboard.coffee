require ['spec/helpers/mock', 'spec/helpers/util', 'app/pulsar'], (mock, {hasText, exists}, pulsar) ->

  sendInvite = ->
    pulsar.channel('notify:session:session_foo').emit 'newInvites', {chatId: 'chat_3', type: 'invite'}

  sendWaitingChats = ->
    pulsar.channel('notify:operators').emit 'unansweredCount', {isNew: true, count: 3}

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

    it 'should show an invite badge on the sidebar', ->

      expect($ '#sidebar .notifyInvites .badge').not.toExist()

      # mock chats and send notification
      mock.activeChats()
      sendInvite()

      # should see invite badge in sidebar
      waitsFor hasText('#sidebar .notifyInvites .badge', '2'), 'invite badge in sidebar', 200

    it 'should show an unread badge on the sidebar', ->

      expect($ '#sidebar .notifyUnanswered .badge').not.toExist()

      # send pulsar event
      sendWaitingChats()

      # should see invite badge in sidebar
      waitsFor hasText('#sidebar .notifyUnanswered .badge', '3'), 'unread badge in sidebar', 200
