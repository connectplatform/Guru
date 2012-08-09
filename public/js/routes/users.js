// Generated by CoffeeScript 1.3.3
(function() {

  define(["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "templates/editUser", "templates/deleteUser", "templates/userRow", "app/formBuilder"], function(server, notify, sidebar, sbTemp, editUser, deleteUser, userRow, formBuilder) {
    return function(args, templ) {
      if (!server.cookie('session')) {
        return window.location.hash = '/';
      }
      return server.ready(function() {
        return server.getRoles(function(err, allowedRoles) {
          var extraDataPacker, getFormFields, getNewUser;
          getFormFields = function() {
            return {
              firstName: $('#editUser .firstName').val(),
              lastName: $('#editUser .lastName').val(),
              email: $('#editUser .email').val(),
              role: $('#editUser .role').val(),
              websites: $('#editUser .websites').val(),
              departments: $('#editUser .departments').val()
            };
          };
          getNewUser = function() {
            return {
              firstName: "",
              lastName: "",
              email: "",
              role: "Operator",
              websites: "",
              departments: "",
              allowedRoles: allowedRoles
            };
          };
          extraDataPacker = function(user) {
            user.allowedRoles = allowedRoles;
            return user;
          };
          return server.findUser({}, function(err, users) {
            var formBuild, user, _i, _len, _results;
            if (err) {
              console.log("err retrieving users: " + err);
            }
            formBuild = formBuilder(getFormFields, editUser, deleteUser, server.saveUser, server.deleteUser, extraDataPacker, userRow, users);
            $('#content').html(templ({
              users: users
            }));
            $('#addUser').click(formBuild.addElement(getNewUser(), function(err, savedUser) {
              if (err != null) {
                return notify.error("Error saving user: " + err);
              }
              return $("#userTableBody").append(userRow({
                user: savedUser
              }));
            }));
            _results = [];
            for (_i = 0, _len = users.length; _i < _len; _i++) {
              user = users[_i];
              _results.push(formBuild.wireUpRow(user.id));
            }
            return _results;
          });
        });
      });
    };
  });

}).call(this);
