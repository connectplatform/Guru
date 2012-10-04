(function() {

  define(["policy/registerSessionUpdates", "policy/setOfflineOnUnload"], function(registerSessionUpdates, setOfflineOnUnload) {
    registerSessionUpdates();
    return setOfflineOnUnload();
  });

}).call(this);
