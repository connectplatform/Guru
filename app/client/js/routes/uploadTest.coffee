define ["load/server"], (server) ->
  (_, templ) ->
    server.ready ->
      console.log 'calling awsUpload'
      server.awsUpload (err, fields) ->
        console.log "error: ", err if err?
        console.log 'got fields: ', fields

        $('#content').html templ s3: fields
        console.log 'done rendering template'

        $("submit").click (evt) ->
          evt.preventDefault()

          filePath = 'testFile'

          $('#file-upload [name=key]').val filePath
          $('#file-upload').submit()
