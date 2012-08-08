// Generated by CoffeeScript 1.3.3
(function() {

  define(["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "templates/editUser", "templates/deleteUser", "templates/userRow"], function(server, notify, sidebar, sbTemp, editUser, deleteUser, userRow) {
    return function(args, templ) {
      if (!server.cookie('session')) {
        return window.location.hash = '/';
      }
      return server.ready(function() {
        return server.getRoles(function(err, allowedRoles) {
          var getFormFields, getNewUser;
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
          return server.findUser({}, function(err, users) {
            var formBuilder, getUserById, user, _i, _len, _results,
              _this = this;
            if (err) {
              console.log("err retrieving users: " + err);
            }
            sidebar({}, sbTemp);
            getUserById = function(id) {
              var user, _i, _len;
              for (_i = 0, _len = users.length; _i < _len; _i++) {
                user = users[_i];
                if (user.id === id) {
                  user.allowedRoles = allowedRoles;
                  return user;
                }
              }
            };
            formBuilder = {
              userForm: function(template, user, onComplete) {
                return function(evt) {
                  evt.preventDefault();
                  $("#modalBox").html(template({
                    user: user
                  }));
                  $('#editUser').modal();
                  $('#editUser .saveButton').click(function(evt) {
                    var fields;
                    evt.preventDefault();
                    fields = getFormFields();
                    if (user.id != null) {
                      fields.id = user.id;
                    }
                    return server.saveUser(fields, function(err, savedUser) {
                      onComplete(err, savedUser);
                      if (err != null) {
                        return;
                      }
                      formBuilder.wireUpRow(savedUser.id);
                      return $('#editUser').modal('hide');
                    });
                  });
                  return $('#editUser .cancelButton').click(function(evt) {
                    evt.preventDefault();
                    return $('#editUser').modal('hide');
                  });
                };
              },
              wireUpRow: function(id) {
                var currentUser, deleteUserClicked, editUserClicked;
                currentUser = getUserById(id);
                editUserClicked = formBuilder.userForm(editUser, currentUser, function(err, savedUser) {
                  if (err != null) {
                    return notify.error("Error saving user: " + err);
                  }
                  return $("#userTableBody .userRow[userId=" + currentUser.id + "]").replaceWith(userRow({
                    user: savedUser
                  }));
                });
                deleteUserClicked = function(evt) {
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
              }
            };
            $('#content').html(templ({
              users: users
            }));
            $('#addUser').click(formBuilder.userForm(editUser, getNewUser(), function(err, savedUser) {
              if (err != null) {
                return notify.error("Error saving user: " + err);
              }
              users.push(savedUser);
              return $("#userTableBody").append(userRow({
                user: savedUser
              }));
            }));
            _results = [];
            for (_i = 0, _len = users.length; _i < _len; _i++) {
              user = users[_i];
              _results.push(formBuilder.wireUpRow(user.id));
            }
            return _results;
          });
        });
      });
    };
  });

}).call(this);
