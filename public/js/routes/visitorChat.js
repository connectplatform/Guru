// Generated by CoffeeScript 1.3.1
(function() {

  define(["guru/server", "templates/newChat"], function(server, newChat) {
    return function(_arg, templ) {
      var id;
      id = _arg.id;
      $("#content").html(templ());
      $("#message-form #message").focus();
      return server.refresh(function(services) {
        console.log("username: " + (server.cookie('username')));
        console.log("services: " + services);
        $("#message-form").submit(function() {
          var message;
          if ($("#message").val() !== "") {
            message = $("#message").val();
            server[id](message, function(err, data) {
              if (err && (typeof console !== "undefined" && console !== null)) {
                return console.log(err);
              }
            });
            $("#message").val("");
            $("#chat-display-box").scrollTop($("#chat-display-box").prop("scrollHeight"));
          }
          return false;
        });
        return server.subscribe[id](function(err, data) {
          console.log("recieved from user: " + data.username);
          return $("#chat-display-box").append("<p>" + (unescape(data.username)) + ": " + data.message + "</p>");
        });
      });
    };
  });

}).call(this);