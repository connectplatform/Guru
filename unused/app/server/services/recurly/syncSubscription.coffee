module.exports =
  required: ['accountId', 'seatCount']
  service: ({accountId, seatCount}, done) ->

    # map guru vocab to recurly
    processResult = (result) ->
      status: result?.subscription?.state
      seatCount: parseInt result?.subscription?.quantity?.value or 0

    finished = (actionTaken) ->
      (err, result) ->
        done err, processResult(result).merge actionTaken: actionTaken

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
          finished('Nothing to do.')(null, subscription)
        else
          cancelSubscription args, finished('Canceling subscription.')

      else

        # if there's no subscription, create one
        if not subscription.status
          createSubscription args, finished('Creating a new subscription.')

        # otherwise edit it
        else if seatCount isnt subscription.seatCount
          editSubscription args, finished('Editing existing subscription.')

        else
          finished('Nothing to do.')(null, subscription)
