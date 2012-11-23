module.exports = (params, done) ->
  getRecurlyAccount = config.service 'recurly/getAccount'

  getRecurlyAccount params, (err, data) ->
    done err, {token: data?.account?.hosted_login_token}
