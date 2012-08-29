(function() {
  var countNewInvites, countUnreadMessages, playSound;

  countNewInvites = function(invites) {
    return invites.keys().length;
  };

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

  define(["app/server", "app/notify", "app/pulsar", 'templates/badge'], function(server, notify, pulsar, badge) {
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
          updateBadge(".sidebar-nav .notifyUnanswered", stats.unanswered.length);
          updateBadge(".sidebar-nav .notifyInvites", stats.invites.length);
          updateBadge(".sidebar-nav .notifyUnread", countUnreadMessages(stats.unreadMessages));
          sessionID = server.cookie('session');
          operatorUpdates = pulsar.channel('notify:operators');
          sessionUpdates = pulsar.channel("notify:session:" + sessionID);
          sessionUpdates.on('viewedMessages', function(unread) {
            var newMessages;
            newMessages = countUnreadMessages(unread);
            return updateBadge(".sidebar-nav .notifyUnread", newMessages);
          });
          operatorUpdates.on('unansweredCount', function(_arg) {
            var count, isNew;
            isNew = _arg.isNew, count = _arg.count;
            updateBadge(".sidebar-nav .notifyUnanswered", count);
            if (isNew) return playSound("newChat");
          });
          sessionUpdates.on('unreadMessages', function(unread) {
            var newMessages;
            newMessages = countUnreadMessages(unread);
            updateBadge(".sidebar-nav .notifyUnread", newMessages);
            if (newMessages > 0) return playSound("newMessage");
          });
          return sessionUpdates.on('newInvites', function(invites) {
            var newInvites;
            newInvites = countNewInvites(invites);
            updateBadge(".notifyInvites", newInvites, 'warning');
            if (newInvites > 0) return playSound("newInvite");
          });
        });
      });
    };
  });

}).call(this);
