(function() {

  Object.extend();

  define(["load/server", "load/routes", "load/notify"], function(server, routes, notify) {
    return server.ready(function(services) {});
  });

}).call(this);
