module.exports.accountInGoodStanding = ({accountId}, done) ->
  done(null, {goodStanding: true})

module.exports.syncSubscription = ({accountId, seatCount}, done) ->
  done(null, {})

module.exports.createAccount = ({accountId, owner}, done) ->
  done(null, {})