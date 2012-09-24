(function() {

  define(["load/server", "load/notify"], function(server, notify) {
    return function(args, templ) {
      return server.ready(function() {
        return server.getMyRole(function(err, role) {
          if ((role === 'Operator') || (role === 'Administrator')) {
            return window.location.hash = '/dashboard';
          } else {
            return window.location.hash = '/login';
          }
        });
      });
    };
  });

}).call(this);
