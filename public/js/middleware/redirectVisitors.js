// Generated by CoffeeScript 1.3.3
(function() {

  define(["app/server"], function(server) {
    return function(args, next) {
      if (args.role === 'Visitor') {
        window.location.hash = "#/newChat";
        return next("redirecting visitor to newChat");
      } else {
        return next(null, args);
      }
    };
  });

}).call(this);
