define ['load/server', 'load/notify', 'helpers/util', 'helpers/renderForm'],
  (server, notify, {toTitle, button}, renderForm) ->
    (args, templ) ->

      $('#content').html templ()

      handleErr = (err) ->
        console.log 'error:', err
        if err
          notify.error 'Could not find account.'
        return !!err

      server.ready ->
        async.parallel {
          recurlyData: server.getRecurlyToken
          accounts: (done) -> server.findModel {modelName: 'Account'}, done

        }, (err, data) ->
          return if handleErr err
          {recurlyData, accounts} = data

          if accounts?[0]?.accountType is 'Unlimited'
            $('#recurlyDetails').html "Unlimited Account - no payment details"

          else
            $('#recurlyDetails').html "<iframe height='840' width='620'
              src='https://chatpro.recurly.com/account/#{recurlyData.token}'></iframe>"
