saveModel = config.require 'services/saveModel'

module.exports = ({fields, sessionId}, done) ->
  saveModel {fields: {status: 'Trial'}, modelName: 'Account', sessionId: sessionId }, done
