(function() {

  define([], function() {
    return function(appender, chatChannel) {
      var alreadyReceivedChatMessage, appendChatMessageIfNew, messagesReceived;
      messagesReceived = [];
      alreadyReceivedChatMessage = function(newMessage) {
        var oldMessage, _i, _len;
        for (_i = 0, _len = messagesReceived.length; _i < _len; _i++) {
          oldMessage = messagesReceived[_i];
          if (newMessage.timestamp === oldMessage.timestamp) return true;
        }
        messagesReceived.push(newMessage);
        return false;
      };
      appendChatMessageIfNew = function(message) {
        var rcvd;
        rcvd = alreadyReceivedChatMessage(message);
        if (!rcvd) return appender(message);
      };
      return chatChannel.on('serverMessage', appendChatMessageIfNew);
    };
  });

}).call(this);
