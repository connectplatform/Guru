(function() {

  define(["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "templates/editSpecialty", "templates/deleteSpecialty", "templates/specialtyRow", "app/formBuilder"], function(server, notify, sidebar, sbTemp, editSpecialty, deleteSpecialty, specialtyRow, formBuilder) {
    return function(args, templ) {
      if (!server.cookie('session')) return window.location.hash = '/';
      return server.ready(function() {
        var extraDataPacker, getFormFields, getNewSpecialty;
        getFormFields = function() {
          return {
            name: $('#editSpecialty .name').val()
          };
        };
        getNewSpecialty = function() {
          return {
            name: ""
          };
        };
        extraDataPacker = function(specialty) {
          return specialty;
        };
        return server.findModel({}, "Specialty", function(err, specialties) {
          var formBuild, specialty, _i, _len, _results;
          if (err) console.log("err retrieving specialties: " + err);
          formBuild = formBuilder(getFormFields, editSpecialty, deleteSpecialty, extraDataPacker, specialtyRow, specialties, "specialty");
          $('#content').html(templ({
            specialties: specialties
          }));
          $('#addSpecialty').click(formBuild.elementForm(editSpecialty, getNewSpecialty(), function(err, savedSpecialty) {
            if (err != null) return notify.error("Error saving specialty: " + err);
            formBuild.setElement(savedSpecialty);
            return $("#specialtyTableBody").append(specialtyRow({
              specialty: savedSpecialty
            }));
          }));
          _results = [];
          for (_i = 0, _len = specialties.length; _i < _len; _i++) {
            specialty = specialties[_i];
            _results.push(formBuild.wireUpRow(specialty.id));
          }
          return _results;
        });
      });
    };
  });

}).call(this);
