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

        }, (err, data) ->
          return if handleErr err
          {recurlyData} = data

          $('#recurlyDetails').html "<iframe height='800' width='620'
            src='https://chatpro.recurly.com/account/#{recurlyData.token}'></iframe>"


      # if we decide to present more info in the future

      #options =
        #title: 'Account Details'
        #placement: '.form-area'
        #submit: 'disabled'

          #accounts: (done) -> server.findModel {modelName: 'Account'}, done

          #[account] = accounts

          #fields = for fieldName, fieldVal of account when fieldName in ['status']
            #{
              #label: toTitle fieldName
              #name: fieldName
              #value: fieldVal
              #inputType: 'static'
            #}

          #fields.add
            #inputType: 'button'
            #value: 'Edit Billing Info'
            #btnStyle: 'primary'
            #href: ""

          #renderForm options, fields
