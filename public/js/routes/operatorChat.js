(function() {

  define(["app/server", "app/pulsar", "app/notify", "routes/chatControls", "templates/chatMessage", "templates/serverMessage", "templates/badge"], function(server, pulsar, notify, controls, chatMessage, serverMessage, badge) {
    return function(args, templ) {
      var renderId, sessionId, sessionUpdates;
      sessionId = server.cookie("session");
      sessionUpdates = pulsar.channel("notify:session:" + sessionId);
      renderId = function(id) {
        return id.replace(/:/g, '-');
      };
      return server.ready(function(services) {
        return server.getMyChats(function(err, chats) {
          var channel, chat, createChatAppender, createChatRemover, createSubmitHandler, ran, updateChatBadge, _i, _j, _len, _len2, _results;
          console.log('chats:', chats);
          for (_i = 0, _len = chats.length; _i < _len; _i++) {
            chat = chats[_i];
            chat.renderedId = renderId(chat.id);
          }
          $('#content').html(templ({
            chats: chats
          }));
          console.log('wiring up chatTabs');
          $('#chatTabs a').click(function(e) {
            var currentChat;
            e.preventDefault();
            $(this).tab('show');
            currentChat = $(this).attr('chatid');
            return sessionUpdates.emit('viewedMessages', currentChat, true);
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
              if (thisChatId !== endedId) return;
              channel.removeAllListeners('serverMessage');
              renderedId = renderId(endedId);
              $("#" + renderedId + " .chat-display-box").append(serverMessage({
                message: "Another operator has taken this chat"
              }));
              return $(".message-form").hide();
            };
          };
          updateChatBadge = function(chatId) {
            return function(unreadMessages) {
              var content, unreadCount;
              console.log('received unread:', unreadMessages);
              unreadCount = unreadMessages[chatId] || 0;
              console.log('unread count:', unreadCount, 'for chatId:', chatId);
              if (unreadCount > 0) {
                console.log('setting badge:', unreadCount);
                content = badge({
                  status: 'important',
                  num: unreadCount
                });
              } else {
                console.log('unsetting badge');
                content = '';
              }
              return $(".notifyUnread[chatid=" + chatId + "]").html(content);
            };
          };
          _results = [];
          for (_j = 0, _len2 = chats.length; _j < _len2; _j++) {
            chat = chats[_j];
            channel = pulsar.channel(chat.id);
            if (chat.isWatching) {
              $("#" + chat.renderedId + " .message-form").hide();
            } else {
              $("#" + chat.renderedId + " .message-form").submit(createSubmitHandler(chat.renderedId, channel));
            }
            channel.on('serverMessage', createChatAppender(chat.renderedId));
            sessionUpdates.on('kickedFromChat', createChatRemover(chat.id, channel));
            sessionUpdates.on('unreadMessages', updateChatBadge(chat.id));
            $("#" + chat.renderedId + " .inviteButton").click(controls.createInviteHandler(chat.id));
            $("#" + chat.renderedId + " .transferButton").click(controls.createTransferHandler(chat.id));
            $("#" + chat.renderedId + " .kickButton").click(controls.createKickHandler(chat.id, chat.renderedId));
            $("#" + chat.renderedId + " .leaveButton").click(controls.createLeaveHandler(chat.id));
            ran = false;
            _results.push(window.rooter.hash.listen(function(newHash) {
              if (!ran) {
                ran = true;
                channel.removeAllListeners('serverMessage');
                sessionUpdates.removeAllListeners('kickedFromChat');
                return sessionUpdates.removeAllListeners('unreadMessages');
              }
            }));
          }
          return _results;
        });
      });
    };
  });

}).call(this);
