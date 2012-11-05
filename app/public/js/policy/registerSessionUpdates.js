(function() {
  var __slice = Array.prototype.slice;

  define(["load/pulsar", "load/server"], function(pulsar, server) {
    return function() {
      var session, sessionUpdates;
      session = server.cookie('session');
      if (session != null) {
        sessionUpdates = pulsar.channel("notify:session:" + session);
        return sessionUpdates.use(function() {
          var args, currentChat, emit, event, unreadCount, unreadMessages;
          emit = arguments[0], event = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
          if (event === 'unreadMessages') {
            unreadMessages = args[0];
            currentChat = $('.chatWindow:visible').attr('chatid');
            unreadCount = unreadMessages[currentChat];
            if ((currentChat != null) && unreadCount > 0) {
              unreadMessages[currentChat] = 0;
              sessionUpdates.emit('viewedMessages', currentChat);
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
