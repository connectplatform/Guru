(function() {

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
          var operatorUpdates, sessionID, sessionUpdates, updateUnreadMessages;
          updateBadge(".notifyUnanswered", stats.unanswered.length);
          updateBadge(".notifyInvites", stats.invites.length);
          sessionID = server.cookie('session');
          operatorUpdates = pulsar.channel('notify:operators');
          sessionUpdates = pulsar.channel("notify:session:" + sessionID);
          updateUnreadMessages = function(unread) {
            var chat, count, total;
            total = 0;
            for (chat in unread) {
              count = unread[chat];
              total += count;
            }
            return updateBadge(".notifyUnread", total);
          };
          operatorUpdates.on('unansweredCount', function(num) {
            return updateBadge(".notifyUnanswered", num);
          });
          sessionUpdates.on('unreadMessages', updateUnreadMessages);
          sessionUpdates.on('viewedMessages', updateUnreadMessages);
          return sessionUpdates.on('newInvites', function(invites) {
            return updateBadge(".notifyInvites", invites.keys().length, 'warning');
          });
        });
      });
    };
  });

}).call(this);
