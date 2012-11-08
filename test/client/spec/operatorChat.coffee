require ['spec/helpers/mock', 'spec/helpers/util', 'load/pulsar'],
  (mock, {defaultTimeout, hasText, exists, delay}, pulsar) ->

    describe 'Operator Chat', ->
      beforeEach ->
        mock.services()
        mock.loggedIn()

        # given I have 2 current chats
        mock.hasChats()

        # and I am on the page for one of them
        window.location.hash = '/operatorChat'
        waitsFor exists('#chatTabs'), 'Operator Chats did not load', defaultTimeout

      afterEach ->
        mock.loggedOut()
        window.location.hash = '/test'

      it 'should show unread messages for chats without focus', ->

        # when I get a message for the other
        pulsar.channel("notify:session:session_foo").emit 'unreadMessages', {chat_1: 2, chat_2: 3}

        # it should update the badge for that chat
        waitsFor hasText('#chatTabs .notifyUnread[chatid=chat_2]', '3'), 'Did not update unread messages', defaultTimeout

      it 'should not show unread messages for the current chat', ->

        # when I get a message for the other
        pulsar.channel("notify:session:session_foo").emit 'unreadMessages', {chat_1: 2, chat_2: 3}

        # it should update the badge for that chat
        waitsFor hasText('#chatTabs .notifyUnread[chatid=chat_2]', '3'), 'Did not update unread messages', defaultTimeout
        expect($ '#chatTabs .notifyUnread[chatid=chat_1]').toBeEmpty()
        ###
#TODO: somehow hashchanges refuse to work here, and every change goes to "/operatorChat"
      it 'should not show duplicate chat messages', ->
        window.location.hash = "/userProfile"
        waitsFor exists(".password-change-form"), defaultTimeout
        window.location.hash = "/operatorChat"
        waitsFor exists(".chat-display-box"), 200

        pulsar.channel("chat_1").emit 'serverMessage', {username: "Bob", message: "aMessage"}
        waitsFor exists $(".chat-display-box aMessage"), defaultTimeout

        expect( $(".chat-display-box p").length).toEqual 1
###

      describe 'Sidebar', ->

        it 'should only show message count for unread chats', ->

          # when I get a message for the other
          pulsar.channel("notify:session:session_foo").emit 'unreadMessages', {chat_1: 2, chat_2: 3}

          # it should update the badge for that chat
          waitsFor hasText('#chatTabs .notifyUnread[chatid=chat_2]', '3'), 'Did not update unread messages', defaultTimeout
          expect($ '.nav-list .notifyUnread').toHaveText '3'
