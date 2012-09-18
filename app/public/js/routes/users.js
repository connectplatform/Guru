(function() {

  define(["load/server", "load/notify", "templates/editUser", "templates/deleteUser", "templates/userRow", "helpers/formBuilder"], function(server, notify, editUser, deleteUser, userRow, formBuilder) {
    return function(args, templ) {
      if (!server.cookie('session')) return window.location.hash = '/';
      return server.ready(function() {
        return server.findModel({}, "Website", function(err, websites) {
          return server.findModel({}, "Specialty", function(err, specialties) {
            var validSpecialtyNames, validWebsiteNames;
            validWebsiteNames = websites.map(function(site) {
              return site.name;
            });
            validSpecialtyNames = specialties.map(function(specialty) {
              return specialty.name;
            });
            return server.getRoles(function(err, allowedRoles) {
              var extraDataPacker, getFormFields, getNewUser;
              getFormFields = function() {
                var thing;
                return {
                  firstName: $('#editUser .firstName').val(),
                  lastName: $('#editUser .lastName').val(),
                  email: $('#editUser .email').val(),
                  role: $('#editUser .role').val(),
                  websites: (function() {
                    var _i, _len, _ref, _results;
                    _ref = $('#editUser .websites :checkbox:checked');
                    _results = [];
                    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                      thing = _ref[_i];
                      _results.push($(thing).val());
                    }
                    return _results;
                  })(),
                  specialties: (function() {
                    var _i, _len, _ref, _results;
                    _ref = $('#editUser .specialties :checkbox:checked');
                    _results = [];
                    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                      thing = _ref[_i];
                      _results.push($(thing).val());
                    }
                    return _results;
                  })()
                };
              };
              extraDataPacker = function(user) {
                user.allowedRoles = allowedRoles;
                user.allowedWebsites = validWebsiteNames;
                user.allowedSpecialties = validSpecialtyNames;
                return user;
              };
              getNewUser = function() {
                return extraDataPacker({
                  firstName: "",
                  lastName: "",
                  email: "",
                  role: "Operator",
                  websites: [],
                  specialties: []
                });
              };
              return server.findModel({}, "User", function(err, users) {
                var formBuild, user, _i, _len, _results;
                if (err) console.log("err retrieving users: " + err);
                formBuild = formBuilder(getFormFields, editUser, deleteUser, extraDataPacker, userRow, users, "user");
                $('#content').html(templ({
                  users: users
                }));
                $('#addUser').click(formBuild.elementForm(editUser, getNewUser(), function(err, savedUser) {
                  if (err != null) {
                    return notify.error("Error saving user: " + err);
                  }
                  formBuild.setElement(savedUser);
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
        });
      });
    };
  });

}).call(this);