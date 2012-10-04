(function() {

  define(['load/server'], function(server) {
    return function() {
      return $(window).unload(function() {
        return server.setSessionOffline(server.cookie('session'));
      });
    };
  });

}).call(this);
