(function() {

  define(["app/server", "app/notify"], function(server, notify) {
    return function(_, templ) {
      $("#content").html("Loading...");
      return server.ready(function() {
        return server.getExistingChatChannel(function(err, data) {
          if ((data != null) && !!data) {
            window.location.hash = "/visitorChat/" + data.channel;
          }
          $("#content").html(templ());
          $("#newChat-form #username").focus();
          return $("#newChat-form").submit(function() {
            var username;
            username = $("#newChat-form #username").val();
            server.newChat({
              username: username
            }, function(err, data) {
              if (err != null) {
                $("#content").html(templ());
                return notify.error("Error connecting to chat: " + err);
              } else {
                return window.location.hash = "/visitorChat/" + data.channel;
              }
            });
            $("#content").html("Connecting to chat...");
            return false;
          });
        });
      });
    };
  });

}).call(this);
