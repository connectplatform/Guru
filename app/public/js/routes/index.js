(function() {

  define(["load/server", "load/notify"], function(server, notify) {
    return function(args, templ) {
      return server.ready(function() {
        return server.getMyRole({}, function(err, role) {
          switch (role) {
            case 'Visitor':
              return window.location.hash = '/newChat';
            case 'None':
              return window.location.hash = '/login';
            default:
              return window.location.hash = '/dashboard';
          }
        });
      });
    };
  });

}).call(this);
