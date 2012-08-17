(function() {

  define(["ext/pulsar"], function(Pulsar) {
    return Pulsar.createClient({
      port: 4001
    });
  });

}).call(this);
