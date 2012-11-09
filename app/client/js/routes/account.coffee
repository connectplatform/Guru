define ['load/server', 'load/notify', 'helpers/util', 'helpers/renderForm'],
  (server, notify, {toTitle}, renderForm) ->
    (args, templ) ->

      $('#content').html templ()

      options =
        title: 'Account Details'
        placement: '.form-area'
        submit: 'disabled'

      server.ready ->
        server.findModel {modelName: 'Account'}, (err, accounts) ->
          if err
            $(options.placement).html 'Could not find account.'
            return

          [account] = accounts

          fields = for fieldName, fieldVal of account when fieldName isnt '_id'
            {
              label: toTitle fieldName
              name: fieldName
              value: fieldVal
              inputType: 'static'
            }

          renderForm options, fields
