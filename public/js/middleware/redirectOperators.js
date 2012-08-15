(function() {

  define(["app/server"], function(server) {
    return function(args, next) {
      return $(function() {
        return server.ready(function() {
          return server.getMyRole(function(err, role) {
            if (role !== "Operator") {
              return next();
            } else {
              window.location.hash = "#/dashboard";
              return next("redirecting operator to dashboard");
            }
          });
        });
      });
    };
  });

}).call(this);
