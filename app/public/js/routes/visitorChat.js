// Generated by CoffeeScript 1.3.3
(function() {

  define(["load/server", "load/pulsar", "load/notify", "templates/newChat", "templates/chatMessage", "templates/serverMessage", "helpers/wireUpChatAppender", "templates/imageTemplate"], function(server, pulsar, notify, newChat, chatMessage, serverMessage, wireUpChatAppender, imageTemplate) {
    return {
      channel: {},
      setup: function(_arg, templ) {
        var chatId, self;
        chatId = _arg.chatId;
        self = this;
        return server.ready(function() {
          return server.visitorCanAccessChannel(chatId, function(err, canAccess) {
            var appendChatMessage, appendServerMessage, displayGreeting;
            console.log("canAccess: ", canAccess);
            if (!canAccess) {
              return window.location.hash = '/newChat';
            }
            $("#content").html(templ());
            console.log("rendered");
            $("#message-form #message").focus();
            self.channel = pulsar.channel(chatId);
            $(".message-form").submit(function(evt) {
              var message;
              evt.preventDefault();
              if ($(".message").val() !== "") {
                message = $(".message").val();
                self.channel.emit('clientMessage', {
                  message: message,
                  session: server.cookie('session')
                });
                $(".message").val("");
                $(".chat-display-box").scrollTop($(".chat-display-box").prop("scrollHeight"));
              }
              return false;
            });
            appendChatMessage = function(message) {
              return $(".chat-display-box").append(chatMessage(message));
            };
            appendServerMessage = function(message) {
              return $(".chat-display-box").append(serverMessage({
                message: message
              }));
            };
            displayGreeting = function() {
              return appendServerMessage("Welcome to live chat!  An operator will be with you shortly.");
            };
            server.getChatHistory(chatId, function(err, history) {
              var msg, _i, _len;
              if (err) {
                notify.error("Error loading chat history: " + err);
              }
              for (_i = 0, _len = history.length; _i < _len; _i++) {
                msg = history[_i];
                appendChatMessage(msg);
              }
              if (history.length === 0) {
                displayGreeting();
              }
              wireUpChatAppender(appendChatMessage, self.channel);
              return self.channel.on('chatEnded', function() {
                self.channel.removeAllListeners('serverMessage');
                appendServerMessage("The operator has ended the chat");
                return $(".message-form").hide();
              });
            });
            server.getLogoForChat(chatId, function(err, logoUrl) {
              console.log("logoUrl: ", logoUrl);
              if (err) {
                notify.error("Error getting logo url: " + err);
              }
              return $(".websiteLogo").html(imageTemplate({
                source: logoUrl
              }));
            });
            return $('.leaveButton').click(function(evt) {
              evt.preventDefault();
              server.kickUser(chatId, function(err) {
                if (err) {
                  return notify.error("Error leaving chat: " + err);
                }
              });
              return appendServerMessage('You have left the chat.');
            });
          });
        });
      },
      teardown: function(cb) {
        var ran;
        ran = true;
        this.channel.removeAllListeners('serverMessage');
        this.channel.removeAllListeners('chatEnded');
        return cb();
      }
    };
  });

}).call(this);
