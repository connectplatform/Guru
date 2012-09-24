(function() {

  define(["app/config", "vendor/pulsar"], function(config, _) {
    return Pulsar.createClient({
      port: config.pulsarPort
    });
  });

}).call(this);
