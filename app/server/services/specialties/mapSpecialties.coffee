{curry} = config.require 'load/util'
async = require 'async'

module.exports =
  required: ['model', 'getter']
  service: ({model, getter}, next) ->
    if model.specialties and not model.specialties.isEmpty()
      getterFn = config.require "services/specialties/#{getter}"
      getterFn model.accountId, model.specialties, (err, translated) ->
        return next "Could not translate specialties: #{err}" if err or not translated or translated.isEmpty()

        # return an error if we have any non-matches
        for t in translated when not t?
          orig = model.specialties[translated.indexOf(t)]
          return next "#{getter} - Could not find specialty by: '#{orig}'."

        model.specialties = translated
        next null, model

    else
      next null, model
