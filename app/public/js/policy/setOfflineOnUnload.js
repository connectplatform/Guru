(function() {

  define(['load/server'], function(server) {
    return function() {
      return $(window).unload(function() {
        return server.setSessionOffline({
          sessionId: server.cookie('session')
        }, function() {});
      });
    };
  });

}).call(this);
