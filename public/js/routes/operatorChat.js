// Generated by CoffeeScript 1.3.3
(function() {

  define(["app/server", "app/pulsar", "app/notify", "routes/chatControls", "routes/sidebar", "templates/sidebar", "templates/chatMessage", "templates/serverMessage"], function(server, pulsar, notify, controls, sidebar, sbTemp, chatMessage, serverMessage) {
    return function(args, templ) {
      var renderId, sessionID, sessionUpdates;
      sidebar({}, sbTemp);
      sessionID = server.cookie("session");
      sessionUpdates = pulsar.channel("notify:session:" + sessionID);
      renderId = function(id) {
        return id.replace(/:/g, '-');
      };
      return server.ready(function(services) {
        console.log("server is ready-- services availible: " + services);
        return server.getMyChats(function(err, chats) {
          var channel, chat, createChatAppender, createChatRemover, createSubmitHandler, _i, _j, _len, _len1, _results;
          for (_i = 0, _len = chats.length; _i < _len; _i++) {
            chat = chats[_i];
            chat.renderedId = renderId(chat.id);
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
          createChatRemover = function(thisChatId, channel) {
            return function(endedId) {
              var renderedId;
              console.log("chatRemover was called: endedId:" + endedId + ", thisChatId:" + thisChatId);
              if (thisChatId !== endedId) {
                return;
              }
              console.log("got here");
              channel.removeAllListeners('serverMessage');
              renderedId = renderId(endedId);
              $("#" + renderedId + " .chat-display-box").append(serverMessage({
                message: "Another operator has taken over this chat"
              }));
              return $(".message-form").hide();
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
            sessionUpdates.on('kickedFromChat', createChatRemover(chat.id, channel));
            $(window).bind('hashchange', function() {
              channel.removeAllListeners('serverMessage');
              return sessionUpdates.removeAllListeners('kickedFromChat');
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
