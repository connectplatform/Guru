(function() {

  define(["load/server"], function(server) {
    return function(args, next) {
      if (args.role === "Operator") {
        window.location.hash = "#/dashboard";
        return next("redirecting operator to dashboard");
      } else {
        return next(null, args);
      }
    };
  });

}).call(this);