(function() {

  define(['load/server'], function(server) {
    return function(action, next) {
      if (next == null) {
        next = function(err, data) {
          if (data) return window.location.hash = '/operatorChat';
        };
      }
      return $("." + action).click(function(evt) {
        var chatId;
        evt.preventDefault();
        chatId = $(this).attr('chatId');
        return server[action]({
          chatId: chatId
        }, function(err, data) {
          if (err) {
            server.log('Error performing dashboard action', {
              error: err,
              severity: 'warn',
              action: action
            });
          }
          return next(err, data);
        });
      });
    };
  });

}).call(this);
