# this is a big hack because we can't load services as filters
types = config.require 'load/argumentTypes'
accountIdLookup = types.find((t) -> t.typeName is 'AccountId').lookup

module.exports = (args, next) ->
  accountIdLookup args, (err, accountId) ->
    next err, args.merge accountId: accountId
