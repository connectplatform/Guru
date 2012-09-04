(function() {

  define(["load/server", "load/routes", "load/notify"], function(server, routes, notify) {
    Object.extend();
    return server.ready(function(services) {
      return console.log("Connected - Available services: " + services);
    });
  });

}).call(this);
