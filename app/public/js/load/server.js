(function() {

  define(["app/config", "vendor/vein"], function(config, _) {
    return Vein.createClient({
      port: config.port
    });
  });

}).call(this);
