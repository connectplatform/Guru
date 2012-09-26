(function() {

  define(["load/server", "load/pulsar", "load/notify", "routes/chatControls", "templates/chatMessage", "templates/serverMessage", "templates/badge", "helpers/util", "helpers/wireUpChatAppender", "templates/imageTemplate"], function(server, pulsar, notify, controls, chatMessage, serverMessage, badge, util, wireUpChatAppender, imageTemplate) {
    return {
      channels: [],
      setup: function(args, templ) {
        var renderId, self, sessionId;
        console.log("called setup in operatorChat");
        self = this;
        self.channels = [];
        sessionId = server.cookie("session");
        self.sessionUpdates = pulsar.channel("notify:session:" + sessionId);
        renderId = function(id) {
          return id.replace(/:/g, '-');
        };
        return server.ready(function(services) {
          return server.getMyChats(function(err, chats) {
            var channel, chat, createChatAppender, createChatRemover, createSubmitHandler, renderLogo, updateChatBadge, _i, _j, _k, _len, _len2, _len3;
            for (_i = 0, _len = chats.length; _i < _len; _i++) {
              chat = chats[_i];
              chat.renderedId = renderId(chat.id);
              if (chat.visitor.acpData != null) {
                chat.visitor.acpData = JSON.parse(chat.visitor.acpData);
              }
              if (chat.visitor.acpData != null) {
                chat.visitor.acpData = util.jsonToUl(chat.visitor.acpData);
              }
            }
            $('#content').html(templ({
              chats: chats
            }));
            renderLogo = function(chat) {
              console.log("renderLogo called");
              return server.getLogoForChat(chat.id, function(err, logoUrl) {
                if (err != null) notify.error("Error getting logo for chat ", err);
                console.log("logoUrl: ", logoUrl);
                return $("#" + chat.renderedId + " .websiteLogo").html(imageTemplate({
                  source: logoUrl
                }));
              });
            };
            for (_j = 0, _len2 = chats.length; _j < _len2; _j++) {
              chat = chats[_j];
              renderLogo(chat);
              $("#acpTree" + chat.renderedId).treeview({
                collapsed: true,
                persist: "location"
              });
            }
            $('#chatTabs a').click(function(e) {
              var currentChat;
              e.preventDefault();
              $(this).tab('show');
              currentChat = $(this).attr('chatid');
              $(".notifyUnread[chatid=" + currentChat + "]").html('');
              return self.sessionUpdates.emit('viewedMessages', currentChat);
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
                unreadCount = unreadMessages[chatId] || 0;
                if (unreadCount > 0) {
                  content = badge({
                    status: 'important',
                    num: unreadCount
                  });
                } else {
                  content = '';
                }
                return $(".notifyUnread[chatid=" + chatId + "]").html(content);
              };
            };
            for (_k = 0, _len3 = chats.length; _k < _len3; _k++) {
              chat = chats[_k];
              channel = pulsar.channel(chat.id);
              self.channels.push(channel);
              if (chat.isWatching) {
                $("#" + chat.renderedId + " .message-form").hide();
              } else {
                $("#" + chat.renderedId + " .message-form").submit(createSubmitHandler(chat.renderedId, channel));
              }
              wireUpChatAppender(createChatAppender(chat.renderedId), channel);
              self.sessionUpdates.on('kickedFromChat', createChatRemover(chat.id, channel));
              self.sessionUpdates.on('unreadMessages', updateChatBadge(chat.id));
              $("#" + chat.renderedId + " .inviteButton").click(controls.createHandler('inviteOperator', chat.id));
              $("#" + chat.renderedId + " .transferButton").click(controls.createHandler('transferChat', chat.id));
              $("#" + chat.renderedId + " .kickButton").click(controls.createKickHandler(chat.id, chat.renderedId));
              $("#" + chat.renderedId + " .leaveButton").click(controls.createLeaveHandler(chat.id));
            }
            return console.log("finished setup in operatorChat");
          });
        });
      },
      teardown: function(cb) {
        var channel, self, _i, _len, _ref;
        console.log("called teardown in operatorChat");
        self = this;
        _ref = self.channels;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          channel = _ref[_i];
          channel.removeAllListeners('serverMessage');
        }
        self.sessionUpdates.removeAllListeners('kickedFromChat');
        self.sessionUpdates.removeAllListeners('unreadMessages');
        self.channels = [];
        console.log("finished teardown in operatorChat");
        return cb();
      }
    };
  });

}).call(this);
