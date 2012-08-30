(function() {

  define(["app/config", "ext/pulsar"], function(config, _) {
    return Pulsar.createClient({
      port: config.pulsarPort
    });
  });

}).call(this);
