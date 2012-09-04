(function() {

  define(["load/server", "load/pulsar", "load/notify", "templates/newChat", "templates/chatMessage", "templates/serverMessage"], function(server, pulsar, notify, newChat, chatMessage, serverMessage) {
    return {
      channel: {},
      setup: function(_arg, templ) {
        var chatId,
          _this = this;
        chatId = _arg.chatId;
        return server.ready(function() {
          return server.visitorCanAccessChannel(chatId, function(err, canAccess) {
            var appendChatMessage;
            if (!canAccess) return window.location.hash = '/newChat';
            $("#content").html(templ());
            $("#message-form #message").focus();
            _this.channel = pulsar.channel(chatId);
            $(".message-form").submit(function(evt) {
              var message;
              evt.preventDefault();
              if ($(".message").val() !== "") {
                message = $(".message").val();
                this.channel.emit('clientMessage', {
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
            return server.getChatHistory(chatId, function(err, history) {
              var msg, _i, _len;
              if (err) notify.error("Error loading chat history: " + err);
              for (_i = 0, _len = history.length; _i < _len; _i++) {
                msg = history[_i];
                appendChatMessage(msg);
              }
              this.channel.on('serverMessage', appendChatMessage);
              return this.channel.on('chatEnded', function() {
                $(".chat-display-box").append(serverMessage({
                  message: "The operator has ended the chat"
                }));
                this.channel.removeAllListeners('serverMessage');
                return $(".message-form").hide();
              });
            });
          });
        });
      },
      teardown: function(cb) {
        var ran, self;
        self = this;
        ran = true;
        this.channel.removeAllListeners('serverMessage');
        this.channel.removeAllListeners('chatEnded');
        return cb();
      }
    };
  });

}).call(this);
