(function() {

  define(["load/server"], function(server) {
    return function(args, next) {
      return server.ready(function() {
        return server.getMyRole(function(err, role) {
          return next(null, args.merge({
            role: role
          }));
        });
      });
    };
  });

}).call(this);
