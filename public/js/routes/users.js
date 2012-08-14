(function() {

  define(["app/server", "app/notify", "templates/editUser", "templates/deleteUser", "templates/userRow"], function(server, notify, editUser, deleteUser, userRow) {
    return function(args, templ) {
      var getFormFields;
      if (!server.cookie('session')) return window.location.hash = '/';
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
      return server.ready(function() {
        return server.getRoles(function(err, allowedRoles) {
          var getNewUser;
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
          return server.findUser({}, function(err, users) {
            var getUserById, user, wireUpRow, _i, _len, _results,
              _this = this;
            if (err != null) console.log("err retrieving users: " + err);
            getUserById = function(id) {
              var user, _i, _len;
              for (_i = 0, _len = users.length; _i < _len; _i++) {
                user = users[_i];
                if (user.id === id) return user;
              }
            };
            wireUpRow = function(id) {
              var deleteUserClicked, editUserClicked;
              editUserClicked = function(evt) {
                var currentUser;
                evt.preventDefault();
                currentUser = getUserById($(this).attr('userId'));
                currentUser.allowedRoles = allowedRoles;
                $("#modalBox").html(editUser({
                  user: currentUser
                }));
                $('#editUser').modal();
                $('#editUser .saveButton').click(function(evt) {
                  var fields;
                  evt.preventDefault();
                  fields = getFormFields();
                  fields.id = currentUser.id;
                  return server.saveUser(fields, function(err, savedUser) {
                    if (err != null) {
                      return notify.error("Error saving user: " + err);
                    }
                    $("#userTableBody .userRow[userId=" + currentUser.id + "]").replaceWith(userRow({
                      user: savedUser
                    }));
                    wireUpRow(currentUser.id);
                    return $('#editUser').modal('hide');
                  });
                });
                return $('#editUser .cancelButton').click(function(evt) {
                  evt.preventDefault();
                  return $('#editUser').modal('hide');
                });
              };
              deleteUserClicked = function(evt) {
                var currentUser;
                evt.preventDefault();
                currentUser = getUserById($(this).attr('userId'));
                $("#modalBox").html(deleteUser({
                  user: currentUser
                }));
                $('#deleteUser').modal();
                $('#deleteUser .deleteButton').click(function(evt) {
                  evt.preventDefault();
                  return server.deleteUser(currentUser.id, function(err) {
                    if (err != null) {
                      return notify.error("Error deleting user: " + err);
                    }
                    $("#userTableBody .userRow[userId=" + currentUser.id + "]").remove();
                    return $('#deleteUser').modal('hide');
                  });
                });
                return $('#deleteUser .cancelButton').click(function() {
                  return $('#deleteUser').modal('hide');
                });
              };
              $("#userTableBody .userRow[userId=" + id + "] .editUser").click(editUserClicked);
              return $("#userTableBody .userRow[userId=" + id + "] .deleteUser").click(deleteUserClicked);
            };
            $('#content').html(templ({
              users: users
            }));
            $('#addUser').click(function(evt) {
              evt.preventDefault();
              $("#modalBox").html(editUser({
                user: getNewUser()
              }));
              $('#editUser').modal();
              $('#editUser .saveButton').click(function(evt) {
                var fields;
                evt.preventDefault();
                fields = getFormFields();
                return server.saveUser(fields, function(err, savedUser) {
                  if (err != null) {
                    return notify.error("Error saving user: " + err);
                  }
                  users.push(savedUser);
                  $("#userTableBody").append(userRow({
                    user: savedUser
                  }));
                  wireUpRow(savedUser.id);
                  return $('#editUser').modal('hide');
                });
              });
              return $('#editUser .cancelButton').click(function(evt) {
                evt.preventDefault();
                return $('#editUser').modal('hide');
              });
            });
            _results = [];
            for (_i = 0, _len = users.length; _i < _len; _i++) {
              user = users[_i];
              _results.push(wireUpRow(user.id));
            }
            return _results;
          });
        });
      });
    };
  });

}).call(this);
