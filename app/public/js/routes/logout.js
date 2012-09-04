(function() {

  define(["load/server"], function(server) {
    return function() {
      server.cookie('session', null);
      return window.location = '/';
    };
  });

}).call(this);
