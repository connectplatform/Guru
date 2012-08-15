(function() {

  define(["app/server", "app/notify", "app/util", "app/pulsar"], function(server, notify, util, pulsar) {
    return function(args, templ) {
      var updateDashboard;
      console.log("wheeeee!");
      if (!server.cookie('session')) return window.location.hash = '/';
      updateDashboard = function() {
        return server.getActiveChats(function(err, chats) {
          var chat, statusLevels, _i, _len;
          if (err != null) console.log("err retrieving chats: " + err);
          statusLevels = {
            waiting: 'important',
            active: 'success',
            vacant: 'default'
          };
          for (_i = 0, _len = chats.length; _i < _len; _i++) {
            chat = chats[_i];
            chat.statusLevel = statusLevels[chat.status];
          }
          $('#content').html(templ({
            chats: chats
          }));
          $('.joinChat').click(function(evt) {
            var chatId;
            chatId = $(this).attr('chatId');
            server.joinChat(chatId, {}, function(err, data) {
              if (err != null) console.log("Error joining chat: " + err);
              if (data) return window.location.hash = '/operatorChat';
            });
            return false;
          });
          $('.watchChat').click(function(evt) {
            var chatId;
            chatId = $(this).attr('chatId');
            server.watchChat(chatId, {}, function(err, data) {
              if (err != null) console.log("Error watching chat: " + err);
              if (data) return window.location.hash = '/operatorChat';
            });
            return false;
          });
          $('.acceptChat').click(function(evt) {
            var chatId;
            chatId = $(this).attr('chatId');
            server.acceptChat(chatId, function(err, result) {
              if (err != null) console.log("Error accepting chat: " + err);
              if (result.status === 'OK') {
                return window.location.hash = '/operatorChat';
              } else {
                notify.alert("Another operator already accepted this chat");
                return updateDashboard();
              }
            });
            return false;
          });
          $('.leaveChat').click(function(evt) {
            var chatId;
            evt.preventDefault();
            chatId = $(this).attr('chatId');
            return server.leaveChat(chatId, function(err) {
              if (err != null) console.log("error leaving chat: " + err);
              return updateDashboard();
            });
          });
          $('.acceptInvite').click(function(evt) {
            var chatId;
            evt.preventDefault();
            chatId = $(this).attr('chatId');
            return server.acceptInvite(chatId, function(err, chatId) {
              if (err != null) console.log("error accepting invite: " + err);
              return window.location.hash = '/operatorChat';
            });
          });
          $('.acceptTransfer').click(function(evt) {
            var chatId;
            evt.preventDefault();
            chatId = $(this).attr('chatId');
            return server.acceptTransfer(chatId, function(err, chatId) {
              if (err != null) console.log("error accepting transfer: " + err);
              return window.location.hash = '/operatorChat';
            });
          });
          return util.autotimer('.counter');
        });
      };
      return server.ready(function() {
        var ran, refresh, updates;
        updateDashboard();
        updates = pulsar.channel('notify:operators');
        refresh = function(num) {
          return updateDashboard();
        };
        updates.on('unansweredCount', refresh);
        ran = false;
        return window.rooter.hash.listen(function(newHash) {
          if (!ran) {
            ran = true;
            util.cleartimers();
            return updates.removeListener('unansweredCount', refresh);
          }
        });
      });
    };
  });

}).call(this);
