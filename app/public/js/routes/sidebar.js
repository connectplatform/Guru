(function() {
  var countUnreadMessages, playSound;

  countUnreadMessages = function(unread) {
    var chat, count, total;
    total = 0;
    for (chat in unread) {
      count = unread[chat];
      total += count;
    }
    return total;
  };

  playSound = function(type) {
    return document.getElementById("" + type + "Sound").play();
  };

  define(["load/server", "load/notify", "load/pulsar", 'templates/badge'], function(server, notify, pulsar, badge) {
    return function(args, templ) {
      var updateBadge;
      updateBadge = function(selector, num, status) {
        var content;
        if (status == null) status = 'important';
        content = num > 0 ? badge({
          status: status,
          num: num
        }) : '';
        return $(selector).html(content);
      };
      return server.ready(function() {
        $('#sidebar').html(templ({
          role: args.role
        }));
        return server.getChatStats(function(err, stats) {
          var operatorUpdates, sessionID, sessionUpdates;
          updateBadge("#sidebar .notifyUnanswered", stats.unanswered.length);
          updateBadge("#sidebar .notifyInvites", stats.invites.length);
          updateBadge("#sidebar .notifyUnread", countUnreadMessages(stats.unreadMessages));
          sessionID = server.cookie('session');
          operatorUpdates = pulsar.channel('notify:operators');
          sessionUpdates = pulsar.channel("notify:session:" + sessionID);
          operatorUpdates.on('unansweredCount', function(_arg) {
            var count, isNew;
            isNew = _arg.isNew, count = _arg.count;
            updateBadge("#sidebar .notifyUnanswered", count);
            if (isNew) return playSound("newChat");
          });
          sessionUpdates.on('newInvites', function(invites) {
            var newInvites;
            newInvites = invites.keys().length;
            updateBadge("#sidebar .notifyInvites", newInvites, 'warning');
            if (newInvites > 0) return playSound("newInvite");
          });
          sessionUpdates.on('unreadMessages', function(unread) {
            var newMessages;
            newMessages = countUnreadMessages(unread);
            updateBadge("#sidebar .notifyUnread", newMessages);
            if (newMessages > 0) return playSound("newMessage");
          });
          return sessionUpdates.on('echoViewed', function(unread) {
            var newMessages;
            newMessages = countUnreadMessages(unread);
            return updateBadge("#sidebar .notifyUnread", newMessages);
          });
        });
      });
    };
  });

}).call(this);
