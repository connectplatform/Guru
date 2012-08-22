(function() {

  define(["app/server"], function(server) {
    return function(_arg, next) {
      var role;
      role = _arg.role;
      if (role === 'None') {
        window.location.hash = "#/login";
        return next("redirecting guest to login");
      } else {
        return next();
      }
    };
  });

}).call(this);
