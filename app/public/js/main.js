(function() {

  define(["app/server", "app/routes", "app/notify"], function(server, routes, notify) {
    Object.extend();
    return server.ready(function(services) {
      return console.log("Connected - Available services: " + services);
    });
  });

}).call(this);
