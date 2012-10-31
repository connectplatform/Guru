(function() {

  define(["load/server", "load/notify", "templates/editUser", "templates/deleteUser", "templates/userRow", "helpers/formBuilder"], function(server, notify, editUser, deleteUser, userRow, formBuilder) {
    return function(args, templ) {
      if (!server.cookie('session')) return window.location.hash = '/';
      return server.ready(function() {
        return server.findModel({}, "Website", function(err, websites) {
          return server.findModel({}, "Specialty", function(err, specialties) {
            var allowedWebsites, validSpecialtyNames;
            allowedWebsites = websites.map(function(site) {
              return {
                url: site.url,
                id: site.id
              };
            });
            console.log('allowedWebsites: ', allowedWebsites);
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
                      _results.push($(thing).attr('websiteId'));
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
                var site, siteId, siteUrls, _i, _len;
                siteUrls = {};
                for (_i = 0, _len = websites.length; _i < _len; _i++) {
                  site = websites[_i];
                  siteUrls[site.id] = site.url;
                }
                user.websiteUrls = (function() {
                  var _j, _len2, _ref, _results;
                  _ref = user.websites;
                  _results = [];
                  for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
                    siteId = _ref[_j];
                    _results.push(siteUrls[siteId]);
                  }
                  return _results;
                })();
                user.allowedRoles = allowedRoles;
                user.allowedWebsites = allowedWebsites;
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
                var formBuild, site, siteId, siteUrls, user, _i, _j, _k, _len, _len2, _len3, _results;
                if (err) {
                  server.log('Error retrieving users on users crud page', {
                    error: err,
                    severity: 'error'
                  });
                }
                siteUrls = {};
                for (_i = 0, _len = websites.length; _i < _len; _i++) {
                  site = websites[_i];
                  siteUrls[site.id] = site.url;
                }
                for (_j = 0, _len2 = users.length; _j < _len2; _j++) {
                  user = users[_j];
                  user.websiteUrls = (function() {
                    var _k, _len3, _ref, _results;
                    _ref = user.websites;
                    _results = [];
                    for (_k = 0, _len3 = _ref.length; _k < _len3; _k++) {
                      siteId = _ref[_k];
                      _results.push(siteUrls[siteId]);
                    }
                    return _results;
                  })();
                  user.allowedWebsites = allowedWebsites;
                  console.log('user: ', user);
                }
                $('#content').html(templ({
                  users: users
                }));
                formBuild = formBuilder(getFormFields, editUser, deleteUser, extraDataPacker, userRow, users, "user");
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
                for (_k = 0, _len3 = users.length; _k < _len3; _k++) {
                  user = users[_k];
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
