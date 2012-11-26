module.exports =
  required: ['accountId']
  optional: ['newSeats']
  service: ({accountId, newSeats}, done) ->
    newSeats ||= 0

    getPaidSeats = config.service 'account/getPaidSeats'
    syncSubscription = config.service 'recurly/syncSubscription'

    getPaidSeats {accountId: accountId}, (err, data) ->
      return done err if err or not data
      seatCount = data.paidSeats + newSeats

      # sync subscriptions
      syncSubscription {accountId: accountId, seatCount: seatCount}, done
