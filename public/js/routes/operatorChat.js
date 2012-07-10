// Generated by CoffeeScript 1.3.3
(function() {

  define(["app/server", "app/pulsar", "app/notify", "routes/sidebar", "templates/sidebar", "templates/chatMessage"], function(server, pulsar, notify, sidebar, sbTemp, chatMessage) {
    return function(args, templ) {
      if (!server.cookie('session')) {
        window.location = '/';
      }
      return server.ready(function(services) {
        console.log("server is ready-- services availible: " + services);
        return server.getMyChats(function(err, chats) {
          var appendChat, channel, chat, _i, _j, _k, _len, _len1, _len2;
          for (_i = 0, _len = chats.length; _i < _len; _i++) {
            chat = chats[_i];
            chat.renderedId = chat.id.replace(/:/g, '-');
          }
          for (_j = 0, _len1 = chats.length; _j < _len1; _j++) {
            chat = chats[_j];
            console.log(chat.creationDate);
          }
          sidebar({}, sbTemp);
          $('#content').html(templ({
            chats: chats
          }));
          $('#chatTabs').click(function(e) {
            e.preventDefault();
            return $(this).tab('show');
          });
          $('#chatTabs a:first').tab('show');
          for (_k = 0, _len2 = chats.length; _k < _len2; _k++) {
            chat = chats[_k];
            channel = pulsar.channel(chat.id);
            console.log("attatching methods to #" + chat.renderedId);
            if (chat.isWatching) {
              $("#" + chat.renderedId + " .message-form").hide();
            } else {
              $("#" + chat.renderedId + " .message-form").submit(function(evt) {
                var message;
                evt.preventDefault();
                message = $("#" + chat.renderedId + " .message-form .message").val();
                if (message !== "") {
                  channel.emit('clientMessage', {
                    message: message,
                    session: server.cookie('session')
                  });
                  $("#" + chat.renderedId + " .message-form .message").val("");
                  $("#" + chat.renderedId + " .chat-display-box").scrollTop($("#" + chat.renderedId + " .chat-display-box").prop("scrollHeight"));
                }
                return false;
              });
            }
            appendChat = function(data) {
              return $("#" + chat.renderedId + " .chat-display-box").append(chatMessage(data));
            };
            channel.on('serverMessage', appendChat);
          }
          return $(window).bind('hashchange', function() {});
        });
      });
    };
  });

}).call(this);
