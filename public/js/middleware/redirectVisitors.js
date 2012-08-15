(function() {

  define(["app/server"], function(server) {
    return function(_arg, next) {
      var role;
      role = _arg.role;
      if (role === 'Visitor') {
        window.location.hash = "#/newChat";
        return next("redirecting visitor to newChat");
      } else {
        return next();
      }
    };
  });

}).call(this);
