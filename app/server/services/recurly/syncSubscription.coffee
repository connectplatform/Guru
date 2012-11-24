module.exports =
  required: ['accountId', 'seatCount']
  service: ({accountId, seatCount}, done) ->

    # map guru vocab to recurly
    processResult = (result) ->
      status: result?.subscription?.state
      seatCount: parseInt result?.subscription?.quantity?.value or 0

    finished = (err, result) ->
      done err, processResult result

    args = {accountId: accountId, quantity: seatCount}


    #TODO: cache on get, remove cache on create/edit/cancel
    getSubscription = config.service 'recurly/getSubscription'
    createSubscription = config.service 'recurly/createSubscription'
    editSubscription = config.service 'recurly/editSubscription'
    cancelSubscription = config.service 'recurly/cancelSubscription'

    # see if we have an existing subscription
    getSubscription {accountId: accountId}, (err, result) ->
      subscription = processResult result
      return done err, subscription if err

      if seatCount is 0
        if not subscription
          done null, subscription
        else
          cancelSubscription args, finished

      else

        # if there's no subscription, create one
        if not subscription.status
          createSubscription args, finished

        # otherwise edit it
        else if seatCount isnt subscription.seatCount
          editSubscription args, finished

        else
          done null, subscription
