(function() {

  define(function() {
    var _ref;
    if (window && !(typeof window !== "undefined" && window !== null ? (_ref = window.console) != null ? _ref.log : void 0 : void 0)) {
      return window.console = {
        log: function() {}
      };
    }
  });

}).call(this);