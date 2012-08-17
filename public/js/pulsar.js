(function() {

  define(["ext/pulsar"], function(_) {
    return Pulsar.createClient({
      port: 4001
    });
  });

}).call(this);
