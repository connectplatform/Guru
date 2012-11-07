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
          default: ''
          label: 'Password'
          required: true
        ,
          name: 'confirmPassword'
          inputType: 'password'
          default: ''
          label: 'Confirm Password'
          validation: (text) ->
            return 'Password confirmation must match.' unless text is $(".controls [name=password]").val()
      ]

      options =
        name: 'createAccount'
        submitText: 'Create Account'
        placement: '#content .form-area'

      server.ready ->
        renderForm options, fields, (params) ->
          console.log 'params:', params.params

          server.createAccount params.params, (err, args) ->
            console.log 'err:', err
            console.log 'args:', args

            if err
              notify err
            else
              window.location.hash = '/account'
