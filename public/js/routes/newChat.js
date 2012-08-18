(function() {

  define(["app/server", "app/notify"], function(server, notify) {
    return function(_, templ, queryString) {
      if (queryString == null) queryString = {};
      $("#content").html("Loading...");
      return server.ready(function() {
        return server.getExistingChatChannel(function(err, data) {
          if ((data != null) && !!data) {
            window.location.hash = "/visitorChat/" + data.channel;
          }
          $("#content").html(templ());
          $("#newChat-form #username").focus();
          return $("#newChat-form").submit(function() {
            var referrer, referrerArray, username;
            username = $("#newChat-form #username").val();
            if (!queryString.websiteUrl) {
              referrer = document.referrer || "";
              referrerArray = referrer.split("/");
              if (referrerAray.length >= 2) {
                queryString.websiteUrl = referrerArray[0] + referrerArray[1] + referrerArray[2];
              }
            }
            server.newChat({
              username: username,
              referrerData: queryString
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
