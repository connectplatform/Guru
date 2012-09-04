(function() {

  define(["config", "vendor/pulsar"], function(config, _) {
    return Pulsar.createClient({
      port: config.pulsarPort
    });
  });

}).call(this);
