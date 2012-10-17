saveModel = config.require 'services/saveModel'

module.exports = (res, fields) ->
  saveModel res, {status: 'Trial'}, 'Account'
