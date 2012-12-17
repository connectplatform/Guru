define ["load/server", "load/notify", "helpers/util", 'helpers/renderForm'],
  (server, notify, util, renderForm) ->
    setup: (args, templ) ->

      $("#content").html templ()

      fields = [
          name: 'email'
          inputType: 'text'
          defaultValue: 'name@example.com'
          label: 'Email'
          validation: (email) ->
            /^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test email
          required: true
        ,
          name: 'firstName'
          inputType: 'text'
          defaultValue: 'Bob'
          label: 'First Name'
          required: true
        ,
          name: 'lastName'
          inputType: 'text'
          defaultValue: 'Smith'
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
          $('.header').html header
          $('.footer').html footer

          renderForm options, fields, (params) ->
            server.createAccount params, (err, args) ->

              if err
                notify.error err
              else
                window.location.hash = '/account'

    teardown: (done) ->
      $('.header').html ''
      $('.footer').html ''
      done()
