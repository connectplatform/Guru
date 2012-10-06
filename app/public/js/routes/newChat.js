(function() {

  define(["load/server", "load/notify", 'helpers/util', 'routes/newChat.fsm'], function(server, notify, util, fsm) {
    var getDomain;
    getDomain = util.getDomain;
    return function(_, templ, queryParams) {
      var renderForm;
      if (queryParams == null) queryParams = {};
      renderForm = function(fields, next) {
        $("#content").html(templ({
          fields: fields
        }));
        $("#newChat-form").find(':input').filter(':visible:first');
        return $("#newChat-form").submit(function(evt) {
          var formParams, toObj;
          evt.preventDefault();
          toObj = function(obj, item) {
            obj[item.name] = item.value;
            return obj;
          };
          formParams = $(this).serializeArray().reduce(toObj, {});
          return next(null, {
            params: formParams
          });
        });
      };
      $("#content").html("Loading...");
      delete queryParams["undefined"];
      if (!queryParams.websiteUrl) {
        queryParams.websiteUrl = getDomain(document.referrer);
      }
      return server.ready(function() {
        return fsm({
          renderForm: renderForm,
          params: queryParams
        }).states.initial();
      });
    };
  });

}).call(this);
