// Generated by CoffeeScript 1.3.3
(function() {

  define(["app/server", "app/pulsar", "app/notify", "routes/chatControls", "routes/sidebar", "templates/sidebar", "templates/chatMessage"], function(server, pulsar, notify, controls, sidebar, sbTemp, chatMessage) {
    return function(args, templ) {
      var sessionID, sessionUpdates;
      sidebar({}, sbTemp);
      sessionID = server.cookie("session");
      sessionUpdates = pulsar.channel("notify:session:" + sessionID);
      return server.ready(function(services) {
        console.log("server is ready-- services availible: " + services);
        return server.getMyChats(function(err, chats) {
          var channel, chat, createChatAppender, createSubmitHandler, _i, _j, _len, _len1, _results;
          for (_i = 0, _len = chats.length; _i < _len; _i++) {
            chat = chats[_i];
            chat.renderedId = chat.id.replace(/:/g, '-');
          }
          $('#content').html(templ({
            chats: chats
          }));
          $('#chatTabs a').click(function(e) {
            var chatID;
            e.preventDefault();
            $(this).tab('show');
            chatID = $(this).attr('chatid');
            console.log('chatID:', chatID);
            return sessionUpdates.emit('viewedChats', chatID);
          });
          $('#chatTabs a:first').click();
          createSubmitHandler = function(renderedId, channel) {
            return function(evt) {
              var message;
              evt.preventDefault();
              message = $("#" + renderedId + " .message-form .message").val();
              if (message !== "") {
                channel.emit('clientMessage', {
                  message: message,
                  session: server.cookie('session')
                });
                $("#" + renderedId + " .message-form .message").val("");
                return $("#" + renderedId + " .chat-display-box").scrollTop($("#" + renderedId + " .chat-display-box").prop("scrollHeight"));
              }
            };
          };
          createChatAppender = function(renderedId) {
            return function(message) {
              return $("#" + renderedId + " .chat-display-box").append(chatMessage(message));
            };
          };
          _results = [];
          for (_j = 0, _len1 = chats.length; _j < _len1; _j++) {
            chat = chats[_j];
            channel = pulsar.channel(chat.id);
            if (chat.isWatching) {
              $("#" + chat.renderedId + " .message-form").hide();
            } else {
              $("#" + chat.renderedId + " .message-form").submit(createSubmitHandler(chat.renderedId, channel));
            }
            channel.on('serverMessage', createChatAppender(chat.renderedId));
            $(window).bind('hashchange', function() {
              return channel.removeAllListeners('serverMessage');
            });
            $("#" + chat.renderedId + " .inviteButton").click(controls.createInviteHandler(chat.id));
            $("#" + chat.renderedId + " .transferButton").click(controls.createTransferHandler(chat.id));
            $("#" + chat.renderedId + " .kickButton").click(controls.createKickHandler(chat.id, chat.renderedId));
            _results.push($("#" + chat.renderedId + " .leaveButton").click(controls.createLeaveHandler(chat.id)));
          }
          return _results;
        });
      });
    };
  });

}).call(this);
