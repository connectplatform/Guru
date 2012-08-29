(function() {

  define(["app/config", "ext/vein"], function(config, _) {
    return Vein.createClient({
      port: config.port
    });
  });

}).call(this);
