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
<<<<<<< HEAD
          return $("#newChat-form").submit(function() {
            var username;
=======
          return $("#newChat-form").submit(function(evt) {
            var referrer, referrerArray, username;
            evt.preventDefault();
>>>>>>> fc7470a9a918d3b1d2cd74d173df53537ee75485
            username = $("#newChat-form #username").val();
            if (!queryString.websiteUrl) {
              queryString.websiteUrl = getDomain(document.referrer);
            }
            server.newChat({
              username: username,
<<<<<<< HEAD
              params: queryString
            }, function(err, data) {
=======
              referrerData: queryString
            }, function(err, chat) {
>>>>>>> fc7470a9a918d3b1d2cd74d173df53537ee75485
              if (err != null) {
                $("#content").html(templ());
                return notify.error("Error connecting to chat: " + err);
              } else {
                return window.location.hash = "/visitorChat/" + chat.chatId;
              }
            });
            return $("#content").html("Connecting to chat...");
          });
        });
      });
    };
  });

}).call(this);
