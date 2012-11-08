(function() {

  define(["load/server"], function(server) {
    return function() {
      return server.ready(function() {
        return server.setSessionOffline({
          sessionId: server.cookie('session')
        }, function(err) {
          server.cookie('session', null);
          return window.location = '/';
        });
      });
    };
  });

}).call(this);
