(function() {

  define(function() {
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
        return server[action](chatId, function(err, data) {
          if (err != null) console.log("Error on '" + action + "': " + err);
          return next(err, data);
        });
      });
    };
  });

}).call(this);
