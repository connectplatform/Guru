(function() {

  define(["app/server", "app/pulsar", "app/notify", "templates/newChat", "templates/chatMessage", "templates/serverMessage"], function(server, pulsar, notify, newChat, chatMessage, serverMessage) {
    return function(_arg, templ) {
      var chatId;
      chatId = _arg.chatId;
      return server.ready(function() {
        return server.visitorCanAccessChannel(chatId, function(err, canAccess) {
          var appendChat, channel;
          console.log("canAccess: " + canAccess);
          console.log("canAccess is true: " + (canAccess === true));
          if (!canAccess) return window.location.hash = '/newChat';
          $("#content").html(templ());
          $("#message-form #message").focus();
          channel = pulsar.channel(chatId);
          $(".message-form").submit(function(evt) {
            var message;
            evt.preventDefault();
            if ($(".message").val() !== "") {
              message = $(".message").val();
              channel.emit('clientMessage', {
                message: message,
                session: server.cookie('session')
              });
              $(".message").val("");
              $(".chat-display-box").scrollTop($(".chat-display-box").prop("scrollHeight"));
            }
            return false;
          });
          appendChat = function(data) {
            return $(".chat-display-box").append(chatMessage(data));
          };
          return server.getChatHistory(chatId, function(err, history) {
            var msg, ran, _i, _len;
            if (err) notify.error("Error loading chat history: " + err);
            for (_i = 0, _len = history.length; _i < _len; _i++) {
              msg = history[_i];
              appendChat(msg);
            }
            channel.on('serverMessage', appendChat);
            channel.on('chatEnded', function() {
              $(".chat-display-box").append(serverMessage({
                message: "The operator has ended the chat"
              }));
              channel.removeAllListeners('serverMessage');
              return $(".message-form").hide();
            });
            ran = false;
            return window.rooter.hash.listen(function(newHash) {
              if (!ran) {
                ran = true;
                channel.removeAllListeners('serverMessage');
                return channel.removeAllListeners('chatEnded');
              }
            });
          });
        });
      });
    };
  });

}).call(this);
