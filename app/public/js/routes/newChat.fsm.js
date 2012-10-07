(function() {

  define(["load/server", "load/notify", 'helpers/util'], function(server, notify, util) {
    return function(_arg) {
      var fsm, params, renderForm;
      renderForm = _arg.renderForm, params = _arg.params;
      fsm = {
        transition: function(err, data) {
          if (err && !(data != null)) {
            return fsm.states.error(err);
          } else if (!(data != null)) {
            return fsm.states.needChat();
          } else if (data.chatId) {
            return fsm.states.gotChat(data.chatId);
          } else if (data.fields) {
            return fsm.states.needParams(err, data.fields);
          } else if (data.noOperators) {
            return fsm.states.noOperators();
          } else if (data.params) {
            data.params = params.merge(data.params);
            return fsm.states.needChat();
          }
        },
        states: {
          error: function(err) {
            $("#content").html("Oops, a problem occurred!  We've been notified, thank you for your patience.");
            if (err != null) {
              return notify.error("Problem connecting to chat: " + err);
            }
          },
          initial: function() {
            return server.getExistingChat(fsm.transition);
          },
          needChat: function() {
            $("#content").html("Connecting to chat...");
            return server.createChatOrGetForm(params, fsm.transition);
          },
          needParams: function(err, fields) {
            if (err != null) notify.error("Problem connecting to chat: " + err);
            return renderForm(fields, fsm.transition);
          },
          gotChat: function(chatId) {
            return window.location.hash = "/visitorChat/" + chatId;
          },
          noOperators: function() {
            return window.location.hash = "/submitQuestion";
          }
        }
      };
      return fsm;
    };
  });

}).call(this);
