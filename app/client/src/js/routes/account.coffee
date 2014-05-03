define ['vendor/async', 'load/server', 'load/notify', 'helpers/util', 'helpers/renderForm'],
  (async, server, notify, {toTitle, button}, renderForm) ->
    (args, templ) ->

      $('#content').html templ()

      handleErr = (err) ->
        console.log 'error:', err
        if err
          notify.error 'Could not find account.'
        return !!err

      server.ready ->
        async.parallel {
          recurlyData: (done) -> server.getBillingToken {}, done
          accounts: (done) -> server.findModel {modelName: 'Account'}, done

        }, (err, data) ->
          return if handleErr err
          {recurlyData, accounts} = data
          accountType = accounts?.data?[0]?.accountType

          if accountType is 'Unlimited'
            $('#recurlyDetails').html "<b>Unlimited Account</b> - No payment details."

          else
            $('#recurlyDetails').html "<iframe height='840' width='620'
              src='https://chatpro.recurly.com/account/#{recurlyData.token}'></iframe>"
