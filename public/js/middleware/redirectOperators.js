(function() {

  define(["app/server"], function(server) {
    return function(_arg, next) {
      var role;
      role = _arg.role;
      if (role === "Operator") {
        window.location.hash = "#/dashboard";
        return next("redirecting operator to dashboard");
      } else {
        return next();
      }
    };
  });

}).call(this);