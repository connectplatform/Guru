(function() {

  define(["load/server", "load/notify", 'helpers/util', 'routes/newChat.fsm'], function(server, notify, util, fsm) {
    var getDomain;
    getDomain = util.getDomain;
    return function(_, templ, queryParams) {
      if (queryParams == null) queryParams = {};
      $("#content").html(templ());
      delete queryParams["undefined"];
      if (!queryParams.websiteUrl) {
        queryParams.websiteUrl = getDomain(document.referrer);
      }
      return server.ready(function() {
        return fsm({
          params: queryParams
        });
      });
    };
  });

}).call(this);
