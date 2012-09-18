(function() {

  define(["load/server"], function(server) {
    return function(args, next) {
      if (args.role === 'None') {
        window.location.hash = "#/login";
        return next("redirecting guest to login");
      } else {
        return next(null, args);
      }
    };
  });

}).call(this);