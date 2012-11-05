(function() {

  define(['load/server', 'load/notify'], function(server, notify) {
    return function(_arg, templ) {
      var chatId;
      chatId = _arg.chatId;
      return server.ready(function() {
        return server.printChat({
          chatId: chatId
        }, function(err, htmlData) {
          if (err != null) {
            notify.error("Error formatting chat for printing: ", err);
          }
          $('#renderedContent').html(htmlData);
          return window.print();
        });
      });
    };
  });

}).call(this);
