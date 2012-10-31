define ["load/server", "load/notify", "helpers/util", 'helpers/renderForm'],
  (server, notify, util, renderForm) ->
    (args, templ) ->
      console.log 'loaded createAccount route'

      $("#content").html templ()

      fields = [
          name: 'email'
          inputType: 'text'
          default: 'name@example.com'
          label: 'Email'
        ,
          name: 'firstName'
          inputType: 'text'
          default: 'Bob'
          label: 'First Name'
        ,
          name: 'lastName'
          inputType: 'text'
          default: 'Smith'
          label: 'Last Name'
        ,
          name: 'password'
          inputType: 'password'
          default: ''
          label: 'Password'
        ,
          name: 'password'
          inputType: 'password'
          default: ''
          label: 'Confirm Password'
      ]

      options =
        name: 'createAccount'
        submitText: 'Create Account'
        placement: '#content .form-area'

      server.ready ->
        renderForm options, fields, (err, params) ->
          console.log 'err:', err if err
          console.log 'params:', params.params

          server.createAccount {fields: params.params}, (err, args) ->
            console.log 'err:', err
            console.log 'args:', args
