{curry} = config.require 'load/util'
async = require 'async'

module.exports =
  required: ['model', 'getter']
  service: ({model, getter}, next) ->
    unless model.specialties.isEmpty()
      getterFn = curry config.service("specialties/#{getter}"), model.accountId
      async.map model.specialties, getterFn, (err, translated) ->

        # return an error if we have any non-matches
        for t in translated when not t?
          orig = model.specialties[translated.indexOf(t)]
          return next "#{getter} - Could not find specialty by: '#{orig}'."

        model.specialties = translated
        next null, model

    else
      next null, model
