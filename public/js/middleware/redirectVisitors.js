(function() {

  define(["app/server"], function(server) {
    return function(args, next) {
      console.log("I ran");
      if (args.role === 'Visitor') {
        window.location.hash = "#/newChat";
        return next("redirecting visitor to newChat");
      } else {
        return next(null, args);
      }
    };
  });

}).call(this);
