(function() {

  define([], function() {
    return function(_arg) {
      var complete, data, error, file, formFields, success;
      formFields = _arg.formFields, file = _arg.file, success = _arg.success, complete = _arg.complete, error = _arg.error;
      data = new FormData();
      data.append('key', formFields.key);
      data.append('acl', formFields.acl);
      data.append('Content-Type', file.type);
      data.append('AWSAccessKeyId', formFields.awsAccessKey);
      data.append('policy', formFields.policy);
      data.append('signature', formFields.signature);
      data.append('file', file);
      return $.ajax({
        url: "https://" + formFields.bucket + ".s3.amazonaws.com/",
        data: data,
        processData: false,
        contentType: false,
        type: 'POST',
        success: success,
        complete: complete,
        error: error
      });
    };
  });

}).call(this);
