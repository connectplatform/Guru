(function() {

  define(["app/server", "app/notify", "app/pulsar", 'templates/badge'], function(server, notify, pulsar, badge) {
    return function(args, templ) {
      var updateBadge;
      $('#sidebar').html(templ());
      updateBadge = function(selector, num) {
        var content;
        content = num > 0 ? badge({
          status: 'important',
          num: num
        }) : '';
        return $(selector).html(content);
      };
      return server.ready(function() {
        var operatorUpdates, sessionID, sessionUpdates;
        sessionID = server.cookie('session');
        operatorUpdates = pulsar.channel('notify:operators');
        sessionUpdates = pulsar.channel("notify:session:" + sessionID);
        server.getChatStats(function(err, stats) {
          return updateBadge(".notifyUnanswered", stats.unanswered.length);
        });
        updateUnreadMessages(function(unread) {
          var chat, count, total;
          total = 0;
          for (chat in unread) {
            count = unread[chat];
            total += count;
          }
          return updateBadge(".notifyUnread", total);
        });
        operatorUpdates.on('unansweredCount', function(num) {
          return updateBadge(".notifyUnanswered", num);
        });
        sessionUpdates.on('unreadMessages', updateUnreadMessages);
        return sessionUpdates.on('viewedMessages', updateUnreadMessages);
      });
    };
  });

}).call(this);
