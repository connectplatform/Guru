(function() {

  define(["load/server", "load/notify", 'helpers/util', 'helpers/renderForm'], function(server, notify, util, renderForm) {
    return function(_arg) {
      var fsm, params;
      params = _arg.params;
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
            $("#content .form-area").html("Oops, a problem occurred!  We've been notified, thank you for your patience.");
            if (err != null) {
              return notify.error("Problem connecting to chat: " + err);
            }
          },
          initial: function() {
            return server.getExistingChat(fsm.transition);
          },
          needChat: function() {
            $("#content .form-area").html("Connecting to chat...");
            return server.createChatOrGetForm(params, fsm.transition);
          },
          needParams: function(err, fields) {
            var options;
            if (err != null) notify.error("Problem connecting to chat: " + err);
            options = {
              name: 'newChat',
              submitText: 'Enter Chat',
              placement: '#content .form-area'
            };
            return renderForm(options, fields, fsm.transition);
          },
          gotChat: function(chatId) {
            return window.location.hash = "/visitorChat/" + chatId;
          },
          noOperators: function() {
            return window.location.hash = "/submitQuestion?" + ($.param(params));
          }
        }
      };
      return fsm.states.initial();
    };
  });

}).call(this);
