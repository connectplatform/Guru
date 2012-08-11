(function() {

  define(["app/server", "app/notify"], function(server, notify) {
    return function(args, templ) {
      if ((server.cookie('session')) != null) {
        return window.location.hash = '/dashboard';
      } else {
        return window.location.hash = '/login';
      }
    };
  });

}).call(this);
