// Generated by CoffeeScript 1.3.3
(function() {

  define(["app/server"], function(server) {
    return function(args, next) {
      console.log("about to call server.ready");
      return server.ready(function() {
        console.log("called it!");
        return next();
      });
    };
  });

  /*
        server.getMyRole (err, role) ->
          if role isnt "Operator"
            next()
          else
            window.location.hash = "#/dashboard"
            next "redirecting operator to dashboard"
  */


}).call(this);
