(function() {

  define(["load/server", "load/notify", "templates/editWebsite", "templates/deleteWebsite", "templates/websiteRow", "helpers/formBuilder", "helpers/submitToAws"], function(server, notify, editWebsite, deleteWebsite, websiteRow, formBuilder, submitToAws) {
    return function(args, templ) {
      if (!server.cookie('session')) return window.location.hash = '/';
      return server.ready(function() {
        return server.findModel({}, "Specialty", function(err, specialties) {
          var extraDataPacker, getFormFields, getNewWebsite, validSpecialtyNames;
          validSpecialtyNames = specialties.map(function(specialty) {
            return specialty.name;
          });
          getFormFields = function() {
            var thing;
            return {
              name: $('#editWebsite .name').val(),
              url: $('#editWebsite .url').val(),
              specialties: (function() {
                var _i, _len, _ref, _results;
                _ref = $('#editWebsite .specialties :checkbox:checked');
                _results = [];
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                  thing = _ref[_i];
                  _results.push($(thing).val());
                }
                return _results;
              })(),
              acpEndpoint: $('#editWebsite .acpEndpoint').val(),
              acpApiKey: $('#editWebsite .acpApiKey').val()
            };
          };
          extraDataPacker = function(website) {
            website.allowedSpecialties = validSpecialtyNames;
            return website;
          };
          getNewWebsite = function() {
            var site;
            site = extraDataPacker({
              name: "",
              url: "",
              specialties: [],
              acpEndpoint: "",
              acpApiKey: ""
            });
            console.log(site);
            return site;
          };
          return server.findModel({}, "Website", function(err, websites) {
            var beforeRender, beforeSubmit, formBuild, website, _i, _len, _results;
            if (err) console.log("err retrieving websites: " + err);
            beforeRender = function(element, cb) {
              return server.awsUpload(element.name, 'logo', function(err, logoFields) {
                return server.awsUpload(element.name, 'online', function(err, onlineFields) {
                  return server.awsUpload(element.name, 'offline', function(err, offlineFields) {
                    return cb({
                      logo: logoFields,
                      online: onlineFields,
                      offline: offlineFields
                    });
                  });
                });
              });
            };
            beforeSubmit = function(element, beforeData, cb) {
              var uploadFunc;
              uploadFunc = function(imageName, next) {
                var submissionData;
                if ($("." + imageName + "Upload")[0].files[0] != null) {
                  submissionData = {
                    formFields: beforeData[imageName],
                    file: $("." + imageName + "Upload")[0].files[0],
                    error: function(arg) {
                      notify.error("error submitting " + imageName + " image");
                      return next();
                    },
                    success: next
                  };
                  return submitToAws(submissionData);
                } else {
                  return next();
                }
              };
              return async.parallel([
                function(next) {
                  return uploadFunc('logo', next);
                }, function(next) {
                  return uploadFunc('online', next);
                }, function(next) {
                  return uploadFunc('offline', next);
                }
              ], cb);
            };
            $('#content').html(templ({
              websites: websites
            }));
            formBuild = formBuilder(getFormFields, editWebsite, deleteWebsite, extraDataPacker, websiteRow, websites, "website", beforeRender, beforeSubmit);
            $('#addWebsite').click(formBuild.elementForm(editWebsite, getNewWebsite(), function(err, savedWebsite) {
              if (err != null) return notify.error("Error saving website: " + err);
              formBuild.setElement(savedWebsite);
              return $("#websiteTableBody").append(websiteRow({
                website: savedWebsite
              }));
            }));
            _results = [];
            for (_i = 0, _len = websites.length; _i < _len; _i++) {
              website = websites[_i];
              _results.push(formBuild.wireUpRow(website.id));
            }
            return _results;
          });
        });
      });
    };
  });

}).call(this);
