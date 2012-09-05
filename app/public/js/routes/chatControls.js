(function() {

  define(["load/server", "templates/serverMessage", "templates/selectUser"], function(server, serverMessage, selectUser) {
    var showUserSelectionBox;
    showUserSelectionBox = function(chatId, cb) {
      return server.getNonpresentOperators(chatId, function(err, users) {
        if (err) console.log("Error getting nonpresent users: " + err);
        $("#selectModal").html(selectUser({
          users: users
        }));
        $("#selectUser").modal();
        return $("#selectUser .select").click(function(evt) {
          var userId;
          userId = $(this).attr('userId');
          evt.preventDefault();
          $("#selectUser").modal("hide");
          return cb(userId);
        });
      });
    };
    return {
      createHandler: function(inviteType, chatId) {
        return function(evt) {
          evt.preventDefault();
          return showUserSelectionBox(chatId, function(userId) {
            if (userId == null) return;
            return server[inviteType](chatId, userId, function(err) {
              if (err) return console.log("error inviting operator: " + err);
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
          return server.leaveChat(chatId, function(err) {
            if (err != null) console.log("error leaving chat: " + err);
            return window.location.hash = '/dashboard';
          });
        };
      }
    };
  });

}).call(this);
