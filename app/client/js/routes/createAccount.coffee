define ["load/server", "load/notify", "helpers/util", 'helpers/renderForm'],
  (server, notify, util, renderForm) ->
    (args, templ) ->

      $("#content").html templ()

      fields = [
          name: 'email'
          inputType: 'text'
          default: 'name@example.com'
          label: 'Email'
          validation: (email) ->
            /^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test email
          required: true
        ,
          name: 'firstName'
          inputType: 'text'
          default: 'Bob'
          label: 'First Name'
          required: true
        ,
          name: 'lastName'
          inputType: 'text'
          default: 'Smith'
          label: 'Last Name'
          required: true
        ,
          name: 'password'
          inputType: 'password'
          label: 'Password'
          required: true
        ,
          name: 'passwordConfirm'
          inputType: 'password'
          label: 'Confirm Password'
          required: true
          linked: ['password']
          validation: (text) ->
            return 'Password confirmation must match.' unless text is $(".controls [name=password]").val()
      ]

      options =
        name: 'createAccount'
        submitText: 'Create Account'
        placement: '#content .form-area'

      server.ready ->

        server.getHeaderFooter (err, {header, footer}) ->
          $("body").prepend header
          $("body").append footer

          renderForm options, fields, (params) ->
            server.createAccount params, (err, args) ->

              if err
                notify.error err
              else
                window.location.hash = '/account'
