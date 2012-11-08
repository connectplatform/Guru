(function() {

  define(["app/config", "vendor/vein"], function(config, _) {
    var server;
    server = Vein.createClient({
      port: config.port
    });
    server.log = function(message, object) {
      return server.serverLog(message, object, function() {});
    };
    return server;
  });

}).call(this);
