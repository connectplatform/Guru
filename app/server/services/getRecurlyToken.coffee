module.exports =
  dependencies:
    services: ['recurly/getAccount']
  service: (params, done, {services}) ->
    getRecurlyAccount = services['recurly/getAccount']

    getRecurlyAccount params, (err, data) ->
      done err, {token: data?.account?.hosted_login_token}
