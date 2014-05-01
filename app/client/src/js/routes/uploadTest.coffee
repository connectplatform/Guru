define ["load/server", 'helpers/submitToAws'], (server, submitToAws) ->
  (_, templ) ->
    server.ready ->
      server.awsUpload {siteUrl: 'aSite', imageName: 'aFile'}, (err, fields) ->

        $('#content').html templ s3: fields

        $("#submit").click (evt) ->
          evt.preventDefault()

          submissionData =
            formFields: fields
            file: $('#uploadFile')[0].files[0]
            success: ->
              alert 'file upload succeeded'

          submitToAws submissionData
