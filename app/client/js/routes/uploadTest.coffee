define ["load/server"], (server) ->
  (_, templ) ->
    server.ready ->
      server.awsUpload (err, fields) ->
        console.log 'server provided fields: ', fields

        $('#content').html templ s3: fields

        $("#submit").click (evt) ->
          evt.preventDefault()

          data = new FormData()
          data.append 'key', fields.key
          #data.append 'acl', fields.acl
          data.append 'Content-Type', $('#uploadFile')[0].files[0].type
          data.append 'AWSAccessKeyId', fields.awsAccessKey
          data.append 'policy', fields.policy
          data.append 'signature', fields.signature
          data.append 'file', $('#uploadFile')[0].files[0]

          notice = ->
            alert 'file upload succeeded'

          complete = (obj) ->
            console.log 'request complete'
            console.log 'status: ', obj.statusText
            console.log 'aws response: ', obj.responseText

          $.ajax {
            url: "https://#{fields.bucket}.s3.amazonaws.com/"
            data: data
            processData: false
            contentType: false
            type: 'POST'
            success: notice
            complete: complete
          }

          false
