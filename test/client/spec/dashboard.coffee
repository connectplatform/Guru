require ['spec/helpers/mock', 'spec/helpers/util', 'load/pulsar'],
  (mock, {hasText, exists}, pulsar) ->
    sendInvite = ->
      pulsar.channel('notify:session:session_foo').emit 'pendingInvites', {chatId: 'chat_3', type: 'invite'}

    sendWaitingChats = ->
      pulsar.channel('notify:session:session_foo').emit 'unansweredChats', {count: 3}, true

    hasChats = ->
      numChats = $('#dashboard table tr').length - 1
      numChats > 1

    describe 'Dashboard', ->

      beforeEach ->
        runs ->
          mock.services()
          mock.loggedIn()
          pulsar.channel('notify:session:session_foo')

          window.location.hash = '/dashboard'
          mock.renderSidebar()

        waitsFor hasText('#dashboard h1', 'Dashboard'), 'dashboard to load', 200

      afterEach ->
        runs ->
          window.location.hash = '/test'
          mock.loggedOut()

      it 'should refresh when an invite is received', ->
        runs ->
          expect(hasChats()).toBeFalsy()

          # mock chats and send notification
          mock.activeChats()
          sendInvite()

        # should see chats
        waitsFor hasChats, 'dashboard to refresh', 200

      it 'should show an invite badge on the sidebar', ->
        runs ->
          expect($ '#sidebar .notifyInvites .badge').not.toExist()

          # mock chats and send notification
          mock.activeChats()
          sendInvite()

        # should see invite badge in sidebar
        waitsFor hasText('#sidebar .notifyInvites .badge', '2'), 'invite badge in sidebar', 200

      it 'should show an unread badge on the sidebar', ->
        runs ->
          expect($ '#sidebar .notifyUnanswered .badge').not.toExist()
          # send pulsar event
          sendWaitingChats()

        # should see invite badge in sidebar
        waitsFor hasText('#sidebar .notifyUnanswered .badge', '3'), 'unread badge in sidebar', 200

      it 'should show department and website information', ->
        runs ->
          mock.activeChats()

        waitsFor hasChats, 'dashboard to refresh', 200

        runs ->
          numChats = $('tbody').children().length
          numWebsites = $('tbody .websiteDomain').length
          numDepartments = $('tbody .departmentName').length

          expect(numWebsites).toBe numChats
          expect(numDepartments).toBe numChats

          expect($('tbody .websiteDomain').eq(1).text()).toBe 'foo.com'
          expect($('tbody .departmentName').eq(1).text()).toBe 'Sales'
