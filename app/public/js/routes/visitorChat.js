(function() {

  define(["load/server", "load/pulsar", "load/notify", "templates/newChat", "templates/chatMessage", "templates/serverMessage", "helpers/wireUpChatAppender", "helpers/chatActions", 'helpers/embedImageIfExists'], function(server, pulsar, notify, newChat, chatMessage, serverMessage, wireUpChatAppender, chatActions, embedImage) {
    return {
      channel: {},
      setup: function(_arg, templ) {
        var chatId, self;
        chatId = _arg.chatId;
        self = this;
        return server.ready(function() {
          return server.visitorCanAccessChannel({
            chatId: chatId
          }, function(err, canAccess) {
            var appendChatMessage, appendServerMessage, displayGreeting;
            if (!canAccess) return window.location.hash = '/newChat';
            $("#content").html(templ());
            $(".message-form .message").focus();
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
            server.getChatHistory({
              chatId: chatId
            }, function(err, history) {
              var msg, _i, _len;
              if (err) notify.error("Error loading chat history: " + err);
              for (_i = 0, _len = history.length; _i < _len; _i++) {
                msg = history[_i];
                appendChatMessage(msg);
              }
              if (history.length === 0) displayGreeting();
              wireUpChatAppender(appendChatMessage, self.channel);
              return self.channel.on('chatEnded', function() {
                self.channel.removeAllListeners('serverMessage');
                appendServerMessage("The operator has ended the chat");
                return $(".message-form").hide();
              });
            });
            server.getLogoForChat({
              chatId: chatId
            }, function(err, logoUrl) {
              if (err) notify.error("Error getting logo url: " + err);
              return embedImage(logoUrl, '.websiteLogo');
            });
            $('.leaveButton').click(function(evt) {
              evt.preventDefault();
              return server.leaveChat({
                chatId: chatId
              }, function(err) {
                if (err) notify.error("Error leaving chat: " + err);
                server.cookie('session', null);
                appendServerMessage('You have left the chat.');
                $(".message-form").hide();
                $('.leaveButton').hide();
                self.channel.removeAllListeners('serverMessage');
                return self.channel.removeAllListeners('chatEnded');
              });
            });
            $('.printButton').click(chatActions.print(chatId));
            return $('.emailButton').click(chatActions.email(chatId));
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
