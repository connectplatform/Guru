(function() {

  define(['policy/registerSessionUpdates', 'policy/setOfflineOnUnload', 'load/server'], function(registerSessionUpdates, setOfflineOnUnload, server) {
    registerSessionUpdates();
    setOfflineOnUnload();
    return server.ready(function() {
      return window.onerror = function(message, url, linenumber) {
        return server.serverLog({
          message: "Uncaught error on client",
          error: message,
          url: url,
          linenumber: linenumber
        }, function() {});
      };
    });
  });

}).call(this);
