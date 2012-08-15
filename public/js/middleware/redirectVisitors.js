(function() {

  define(["app/server"], function(server) {
    return function(args, next) {
      return $(function() {
        return server.ready(function() {
          return server.getMyRole(function(err, role) {
            if (role !== "Visitor") {
              return next();
            } else {
              window.location.hash = "#/newChat";
              return next("redirecting visitor to newChat");
            }
          });
        });
      });
    };
  });

}).call(this);
