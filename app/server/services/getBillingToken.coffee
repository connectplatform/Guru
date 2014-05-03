billing =require "../billing"

module.exports = (params, done) ->
  billing.getAccount params, (err, data) ->
    done err, {token: data?.account?.hosted_login_token}
