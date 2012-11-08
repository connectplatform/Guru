define ["load/server", "load/notify", "helpers/util"], #, 'helpers/renderDetails'
  (server, notify, util) -> #, renderDetails
    (args, templ) ->

      $('#content').html templ()

      #options =
        #name: 'account'
        #title: 'Account Details'
        #placement: '#content'

      #server.ready ->
        #server.getAccount {}, (err, {account}) ->
          #console.log 'err:', err
          #console.log 'account:', account

          #renderDetails options, account
