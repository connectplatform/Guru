// Generated by CoffeeScript 1.3.1
(function() {

  define(["guru/server", "guru/routes", "guru/notify"], function(server, routes, notify) {
    return server.ready(function(services) {
      return console.log("Connected - Available services: " + services);
    });
  });

}).call(this);