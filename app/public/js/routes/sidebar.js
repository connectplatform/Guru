(function() {
  var countUnreadMessages, playSound,
    __slice = Array.prototype.slice;

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
        return server.getChatStats({}, function(err, stats) {
          var sessionID, sessionUpdates;
          updateBadge("#sidebar .notifyUnanswered", stats.unanswered.length);
          updateBadge("#sidebar .notifyInvites", stats.invites.length);
          updateBadge("#sidebar .notifyUnread", countUnreadMessages(stats.unreadMessages));
          sessionID = server.cookie('session');
          sessionUpdates = pulsar.channel("notify:session:" + sessionID);
          sessionUpdates.on('unansweredChats', function(_arg, chime) {
            var count;
            count = _arg.count;
            updateBadge("#sidebar .notifyUnanswered", count);
            if (chime === 'true') return playSound("newChat");
          });
          sessionUpdates.on('pendingInvites', function(invites, chime) {
            var pendingInvites;
            pendingInvites = invites.keys().length;
            updateBadge("#sidebar .notifyInvites", pendingInvites, 'warning');
            if ((pendingInvites > 0) && chime === 'true') {
              return playSound("newInvite");
            }
          });
          sessionUpdates.on('unreadMessages', function() {
            var args, chime, newMessages, unread;
            args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
            unread = args[0], chime = args[1];
            newMessages = countUnreadMessages(unread);
            updateBadge("#sidebar .notifyUnread", newMessages);
            if (chime === 'true') return playSound("newMessage");
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
