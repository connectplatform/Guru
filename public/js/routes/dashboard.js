// Generated by CoffeeScript 1.3.3
(function() {

  define(["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "app/util", "app/pulsar"], function(server, notify, sidebar, sbTemp, util, pulsar) {
    return function(args, templ) {
      var updateDashboard, updates;
      if (!server.cookie('session')) {
        return window.location.hash = '/';
      }
      sidebar({}, sbTemp);
      updateDashboard = function() {
        return server.getActiveChats(function(err, chats) {
          if (err) {
            console.log("err retrieving chats: " + err);
          }
          $('#content').html(templ({
            chats: chats
          }));
          $('.joinChat').click(function(evt) {
            var chatId;
            chatId = $(this).attr('chatId');
            server.joinChat(chatId, {}, function(err, data) {
              if (err) {
                console.log("Error joining chat: " + err);
              }
              if (data) {
                return window.location.hash = '/operatorChat';
              }
            });
            return false;
          });
          $('.watchChat').click(function(evt) {
            var chatId;
            chatId = $(this).attr('chatId');
            server.watchChat(chatId, {}, function(err, data) {
              if (err) {
                console.log("Error watching chat: " + err);
              }
              if (data) {
                return window.location.hash = '/operatorChat';
              }
            });
            return false;
          });
          $('.acceptChat').click(function(evt) {
            var chatId;
            chatId = $(this).attr('chatId');
            server.acceptChat(chatId, function(err, result) {
              if (err) {
                console.log("Error watching chat: " + err);
              }
              if (result.status === 'OK') {
                return window.location.hash = '/operatorChat';
              } else {
                notify.alert("Another operator already accepted this chat");
                return updateDashboard();
              }
            });
            return false;
          });
          util.autotimer('.counter');
          return $(window).bind('hashchange', function() {
            return util.cleartimers();
          });
        });
      };
      server.ready(updateDashboard);
      updates = pulsar.channel('notify:operators');
      return updates.on('unansweredCount', function(num) {
        return updateDashboard();
      });
    };
  });

}).call(this);
