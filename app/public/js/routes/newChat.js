(function() {

  define(["load/server", "load/notify", 'helpers/util'], function(server, notify, util) {
    var getDomain;
    getDomain = util.getDomain;
    return function(_, templ, queryString) {
      if (queryString == null) queryString = {};
      $("#content").html("Loading...");
      delete queryString["undefined"];
      return server.ready(function() {
        return server.getExistingChatChannel(function(err, data) {
          if (data) window.location.hash = "/visitorChat/" + data.channel;
          $("#content").html(templ());
          $("#newChat-form #username").focus();
          return $("#newChat-form").submit(function() {
            var username;
            username = $("#newChat-form #username").val();
            if (!queryString.websiteUrl) {
              queryString.websiteUrl = getDomain(document.referrer);
            }
            server.newChat({
              username: username,
              params: queryString
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
