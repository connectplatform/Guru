(function() {

  define(["app/server"], function(server) {
    return function(args, next) {
      console.log("args to redirectOperator: ", args);
      if (args.role === "Operator") {
        window.location.hash = "#/dashboard";
        return next("redirecting operator to dashboard");
      } else {
        return next(null, args);
      }
    };
  });

}).call(this);
