(function() {

  define(["load/server", "load/notify", 'helpers/util'], function(server, notify, util) {
    var getDomain;
    getDomain = util.getDomain;
    return function(_, templ, queryParams) {
      if (queryParams == null) queryParams = {};
      $("#content").html("Loading...");
      delete queryParams["undefined"];
      if (!queryParams.websiteUrl) {
        queryParams.websiteUrl = getDomain(document.referrer);
      }
      return server.ready(function() {
        return server.getExistingChat(function(err, data) {
          if (err != null) console.log("Error getting existing chat:", err);
          if (data != null ? data.chatId : void 0) {
            return window.location.hash = "/visitorChat/" + data.chatId;
          }
          return server.createChatOrGetForm(queryParams, function(err, result) {
            if (err != null) console.log("Error getting chat result:", err);
            if (result != null ? result.chatId : void 0) {
              return window.location.hash = "/visitorChat/" + result.chatId;
            }
            $("#content").html(templ(result));
            $("#newChat-form").find(':input').filter(':visible:first');
            return $("#newChat-form").submit(function(evt) {
              var formParams, toObj;
              evt.preventDefault();
              toObj = function(obj, item) {
                obj[item.name] = item.value;
                return obj;
              };
              formParams = $(this).serializeArray().reduce(toObj, {});
              server.newChat(queryParams.merge(formParams), function(err, data) {
                console.log('got new chat');
                if (err != null) {
                  $("#content").html(templ(result));
                  return notify.error("Error connecting to chat: " + err);
                } else {
                  return window.location.hash = "/visitorChat/" + data.chatId;
                }
              });
              return $("#content").html("Connecting to chat...");
            });
          });
        });
      });
    };
  });

}).call(this);
