(function() {

  define(["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "templates/editWebsite", "templates/deleteWebsite", "templates/websiteRow", "app/formBuilder"], function(server, notify, sidebar, sbTemp, editWebsite, deleteWebsite, websiteRow, formBuilder) {
    return function(args, templ) {
      if (!server.cookie('session')) return window.location.hash = '/';
      return server.ready(function() {
        var extraDataPacker, getFormFields, getNewWebsite;
        getFormFields = function() {
          return {
            name: $('#editWebsite .name').val(),
            url: $('#editWebsite .url').val()
          };
        };
        getNewWebsite = function() {
          return {
            name: "",
            url: ""
          };
        };
        extraDataPacker = function(website) {
          return website;
        };
        return server.findModel({}, "Website", function(err, websites) {
          var formBuild, website, _i, _len, _results;
          if (err) console.log("err retrieving websites: " + err);
          formBuild = formBuilder(getFormFields, editWebsite, deleteWebsite, extraDataPacker, websiteRow, websites, "website");
          $('#content').html(templ({
            websites: websites
          }));
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
    };
  });

}).call(this);
