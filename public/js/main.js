(function() {

  define(["app/server", "app/routes", "app/notify"], function(server, routes, notify) {
    return server.ready(function(services) {
      return console.log("Connected - Available services: " + services);
    });
  });

}).call(this);
