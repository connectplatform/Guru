define [], () ->
  ({formFields, file, success, complete, error}) ->

    data = new FormData()
    data.append 'key', formFields.key
    data.append 'acl', formFields.acl
    data.append 'Content-Type', file.type
    data.append 'AWSAccessKeyId', formFields.awsAccessKey
    data.append 'policy', formFields.policy
    data.append 'signature', formFields.signature
    data.append 'file', file

    $.ajax {
      url: "https://#{formFields.bucket}.s3.amazonaws.com/"
      data: data
      processData: false
      contentType: false
      type: 'POST'
      success: success
      complete: complete
      error: error
    }
