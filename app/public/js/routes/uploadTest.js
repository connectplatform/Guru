(function() {

  define(["load/server", 'helpers/submitToAws'], function(server, submitToAws) {
    return function(_, templ) {
      return server.ready(function() {
        return server.awsUpload({
          siteUrl: 'aSite',
          imageName: 'aFile'
        }, function(err, fields) {
          $('#content').html(templ({
            s3: fields
          }));
          return $("#submit").click(function(evt) {
            var submissionData;
            evt.preventDefault();
            submissionData = {
              formFields: fields,
              file: $('#uploadFile')[0].files[0],
              success: function() {
                return alert('file upload succeeded');
              }
            };
            return submitToAws(submissionData);
          });
        });
      });
    };
  });

}).call(this);
