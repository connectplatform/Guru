define ["app/server"], (server) ->
  (templ) ->
    server.s3Upload (err, fields) ->

      templ s3: fields

      $("submit").click (evt) ->
        evt.preventDefault()

        filePath = 'testFile'

        $('#file-upload [name=key]').val filePath
        $('#file-upload').submit()
