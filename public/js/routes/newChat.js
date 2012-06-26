// Generated by CoffeeScript 1.3.3
(function() {

  define(["guru/server", "guru/notify"], function(server, notify) {
    return function(_, templ) {
      $("#content").html("Loading...");
      return server.ready(function() {
        $("#content").html(templ());
        $("#newChat-form #username").focus();
        return $("#newChat-form").submit(function() {
          var username;
          username = $("#newChat-form #username").val();
          server.cookie('username', username);
          server.newChat({
            username: username
          }, function(err, data) {
            console.log("data: " + data);
            if (err != null) {
              $("#content").html(templ());
              return notify.error("Error logging in: " + err);
            } else {
              return window.location.hash = "/visitorChat/" + data.channel;
            }
          });
          $("#content").html("Connecting to chat...");
          return false;
        });
      });
    };
  });

}).call(this);
