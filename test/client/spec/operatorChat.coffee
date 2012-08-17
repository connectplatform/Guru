require ['spec/helpers/mock', 'spec/helpers/util', 'app/pulsar'],
  (mock, {hasText, exists, delay}, pulsar) ->

    describe 'Operator Chat', ->
      beforeEach ->
        mock.services()
        mock.loggedIn()

        # given I have 2 current chats
        mock.hasChats()

        # and I am on the page for one of them
        window.location.hash = '/operatorChat'
        waitsFor exists('#chatTabs'), 'Operator Chats did not load', 200

      afterEach ->
        mock.loggedOut()
        window.location.hash = '/test'

      it 'should show unread messages for chats without focus', ->

        # when I get a message for the other
        pulsar.channel("notify:session:session_foo").emit 'unreadMessages', {chat_1: 2, chat_2: 3}

        # it should update the badge for that chat
        waitsFor hasText('#chatTabs .notifyUnread[chatid=chat_2]', '3'), 'Did not update unread messages', 200

      it 'should not show unread messages for the current chat', ->

        # when I get a message for the other
        pulsar.channel("notify:session:session_foo").emit 'unreadMessages', {chat_1: 2, chat_2: 3}

        # it should update the badge for that chat
        waitsFor hasText('#chatTabs .notifyUnread[chatid=chat_2]', '3'), 'Did not update unread messages', 200
        expect($ '#chatTabs .notifyUnread[chatid=chat_1]').toBeEmpty()

      describe 'Sidebar', ->

        it 'should only show message count for unread chats', ->

          # when I get a message for the other
          pulsar.channel("notify:session:session_foo").emit 'unreadMessages', {chat_1: 2, chat_2: 3}

          # it should update the badge for that chat
          waitsFor hasText('#chatTabs .notifyUnread[chatid=chat_2]', '3'), 'Did not update unread messages', 200
          expect($ '.nav-list .notifyUnread').toHaveText '3'
