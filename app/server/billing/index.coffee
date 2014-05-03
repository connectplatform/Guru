module.exports.accountInGoodStanding = ({accountId}, done) ->
  done(null, {goodStanding: true})