(function() {
  var __slice = Array.prototype.slice;

  define(["app/pulsar", "app/server"], function(pulsar, server) {
    return function() {
      var session, sessionUpdates;
      session = server.cookie('session');
      if (session != null) {
        sessionUpdates = pulsar.channel("notify:session:" + session);
        console.log('adding pulsar middleware');
        return sessionUpdates.use(function() {
          var args, currentChat, emit, event, unreadCount, unreadMessages;
          emit = arguments[0], event = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
          console.log('intercepted by middleware');
          if (event === 'unreadMessages') {
            unreadMessages = args[0];
            currentChat = $('.chatWindow:visible').attr('chatid');
            unreadCount = unreadMessages[currentChat];
            if ((currentChat != null) && unreadCount > 0) {
              console.log('read chat:', currentChat);
              sessionUpdates.emit('viewedMessages', currentChat, false);
              unreadMessages[currentChat] = 0;
            }
            return emit(unreadMessages);
          } else {
            return emit();
          }
        });
      }
    };
  });

}).call(this);
