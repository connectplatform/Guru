define ["load/server", "load/notify", 'helpers/renderForm'], (server, notify, renderForm) ->
  (_, templ, queryParams={}) ->

    $('#content').html templ()

    options =
      name: 'email'
      placement: '.form-area'

    fields = [
        name: 'email'
        inputType: 'text'
        defaultValue: 'name@example.com'
        label: 'Email'
      ,
        name: 'subject'
        inputType: 'text'
        label: 'Subject'
      ,
        name: 'body'
        inputType: 'paragraph'
        label: 'Message'
    ]

    renderForm options, fields, (err, formData) ->
      return notify.error "Error: #{err}" if err

      args = queryParams.merge {emailData: formData.params}
      server.ready ->
        server.submitQuestion args, (err) ->
          return notify.error "Error: #{err}" if err
          window.location.hash = '/submitSuccess'
