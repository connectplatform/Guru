(function() {

  define(["load/server", "helpers/util", "templates/serverMessage", "templates/selectUser"], function(server, util, serverMessage, selectUser) {
    var showUserSelectionBox;
    showUserSelectionBox = function(chatId, cb) {
      return server.getNonpresentOperators({
        chatId: chatId
      }, function(err, users) {
        if (err) {
          server.log('Error getting nonpresent operators in chatControls', {
            error: err,
            severity: 'error',
            chatId: chatId
          });
        }
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
            return server[inviteType]({
              chatId: chatId
            }, userId, function(err) {
              if (err) {
                return server.log('Error inviting operator to chat', {
                  error: err,
                  severity: 'error',
                  chatId: chatId,
                  userId: userId,
                  inviteType: inviteType
                });
              }
            });
          });
        };
      },
      createKickHandler: function(chatId, renderedId) {
        return function(evt) {
          evt.preventDefault();
          return server.kickUser({
            chatId: chatId
          }, function(err) {
            var chatbox;
            if (err) {
              server.log('Error kicking user', {
                error: err,
                severity: 'error',
                chatId: chatId
              });
            }
            chatbox = $("#" + renderedId + " .chat-display-box");
            return util.append(chatbox, serverMessage({
              message: "The visitor has been kicked from the room"
            }));
          });
        };
      },
      createLeaveHandler: function(chatId) {
        return function(evt) {
          evt.preventDefault();
          return server.leaveChat({
            chatId: chatId
          }, function(err) {
            if (err) {
              server.log('Error leaving chat', {
                error: err,
                severity: 'error',
                chatId: chatId
              });
            }
            return window.location.hash = '/dashboard';
          });
        };
      }
    };
  });

}).call(this);
