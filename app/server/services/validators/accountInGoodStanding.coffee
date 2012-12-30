module.exports = (args, next) ->
  accountInGoodStanding = config.service 'recurly/accountInGoodStanding'
  accountInGoodStanding args, (err, result) ->
    err = 'This feature is not available as your account is not in good standing.' if err or not result
    next err, args
