(function() {

  define(["app/server", "templates/serverMessage", "templates/selectUser"], function(server, serverMessage, selectUser) {
    return {
      createInviteHandler: function(chatId) {
        return function(evt) {
          evt.preventDefault();
          return server.getNonpresentOperators(chatId, function(err, users) {
            if (err) console.log("Error getting nonpresent users: " + err);
            $("#selectModal").html(selectUser({
              users: users
            }));
            $("#selectUser").modal();
            return $("#selectUser .select").click(function(evt) {
              var userId;
              evt.preventDefault();
              userId = $(this).attr('userId');
              $("#selectUser").modal("hide");
              return server.inviteOperator(chatId, userId, function(err) {
                if (err) return console.log("error inviting operator: " + err);
              });
            });
          });
        };
      },
      createTransferHandler: function(chatId) {
        return function(evt) {
          evt.preventDefault();
          return server.getNonpresentOperators(chatId, function(err, users) {
            if (err) console.log("Error getting nonpresent users: " + err);
            $("#selectModal").html(selectUser({
              users: users
            }));
            $("#selectUser").modal();
            return $("#selectUser .select").click(function(evt) {
              var userId;
              evt.preventDefault();
              userId = $(this).attr('userId');
              $("#selectUser").modal("hide");
              return server.transferChat(chatId, userId, function(err) {
                if (err) return console.log("error inviting operator: " + err);
              });
            });
          });
        };
      },
      createKickHandler: function(chatId, renderedId) {
        return function(evt) {
          evt.preventDefault();
          return server.kickUser(chatId, function(err) {
            if (err != null) console.log("error kicking user: " + err);
            return $("#" + renderedId + " .chat-display-box").append(serverMessage({
              message: "The visitor has been kicked from the room"
            }));
          });
        };
      },
      createLeaveHandler: function(chatId) {
        return function(evt) {
          evt.preventDefault();
          console.log("leave clicked");
          return server.leaveChat(chatId, function(err) {
            if (err != null) console.log("error leaving chat: " + err);
            return window.location.hash = '/dashboard';
          });
        };
      }
    };
  });

}).call(this);
