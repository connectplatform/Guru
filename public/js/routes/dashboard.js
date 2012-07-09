// Generated by CoffeeScript 1.3.3
(function() {

  define(["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "app/util"], function(server, notify, sidebar, sbTemp, util) {
    return function(args, templ) {
      if (!server.cookie('session')) {
        return window.location.hash = '/';
      }
      return server.ready(function() {
        return server.getActiveChats(function(err, chats) {
          if (err) {
            console.log("err retrieving chats: " + err);
          }
          sidebar({}, sbTemp);
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
          util.autotimer('.counter');
          return $(window).bind('hashchange', function() {
            return util.cleartimers();
          });
        });
      });
    };
  });

}).call(this);
