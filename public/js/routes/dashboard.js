// Generated by CoffeeScript 1.3.3
(function() {

  define(["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "app/util"], function(server, notify, sidebar, sbTemp, util) {
    return function(args, templ) {
      if (!server.cookie('login')) {
        window.location = '/';
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
          util.autotimer('.counter');
          return $(window).bind('hashchange', function() {
            return util.cleartimers();
          });
        });
      });
    };
  });

}).call(this);
