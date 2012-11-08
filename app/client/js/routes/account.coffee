define ['load/server', 'load/notify', 'helpers/util', 'helpers/renderForm'],
  (server, notify, util, renderForm) ->
    (args, templ) ->

      $('#content').html templ()

      options =
        name: 'account'
        title: 'Account Details'
        placement: '.form-area'

      server.ready ->
        server.findModel {modelName: 'User'}, (err, [account]) ->
          console.log 'err:', err
          console.log 'account:', account

          renderForm options, account
