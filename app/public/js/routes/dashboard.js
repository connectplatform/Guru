(function() {

  define(["load/server", "load/notify", "helpers/util", "load/pulsar", 'helpers/dashboardAction'], function(server, notify, util, pulsar, dashboardAction) {
    return {
      setup: function(args, templ) {
        var updateDashboard;
        updateDashboard = function() {
          if (window.location.hash !== "#/dashboard") return;
          return server.getActiveChats({}, function(err, chats) {
            var chat, statusLevels, _i, _len;
            if (err) {
              server.log('Error retrieving chats on dashboard', {
                error: err,
                severity: 'error'
              });
            }
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
            dashboardAction('joinChat');
            dashboardAction('watchChat');
            dashboardAction('acceptInvite');
            dashboardAction('acceptTransfer');
            dashboardAction('acceptChat', function(err, result) {
              if (result.status === 'OK') {
                return window.location.hash = '/operatorChat';
              } else {
                notify.alert("Another operator already accepted this chat");
                return updateDashboard();
              }
            });
            dashboardAction('leaveChat', function() {
              return updateDashboard();
            });
            return util.autotimer('.counter');
          });
        };
        return server.ready(function() {
          var sessionUpdates;
          updateDashboard();
          sessionUpdates = pulsar.channel("notify:session:" + (server.cookie('session')));
          sessionUpdates.on('unansweredChats', updateDashboard);
          return sessionUpdates.on('pendingInvites', updateDashboard);
        });
      },
      teardown: function(cb) {
        var sessionUpdates;
        util.cleartimers();
        sessionUpdates = pulsar.channel("notify:session:" + (server.cookie('session')));
        sessionUpdates.removeAllListeners('pendingInvites');
        sessionUpdates.removeAllListeners('unansweredChats');
        return cb();
      }
    };
  });

}).call(this);
