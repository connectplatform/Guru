async = require 'async'

db = config.require 'load/mongo'
{Website, Specialty} = db.models

module.exports =
  service: (params, done, sideEffects) ->

    newChat = config.service 'newChat'
    getAvailableOperators = config.service 'operator/getAvailableOperators'
    mapSpecialties = config.service 'specialties/mapSpecialties'

    # set up continuation to be called at the end
    respond = (requiredFields) ->

      # check supplied params vs. required
      remaining = requiredFields.exclude (f) ->
        f.name in params.keys()

      # if we have everything needed, create the chat
      if remaining.isEmpty()
        return newChat params, done, sideEffects

      # otherwise return additional fields required
      else
        done null, {fields: remaining}

    Website.findOne {url: params.websiteUrl}, (err, website) ->

      if err or not website
        config.log.warn 'Could not route chat due to missing website.', {error: err, params: params}
        return done 'Could not route chat due to missing website.'

      # get online status for each of the website's specialties
      if website.specialties and website.specialties.length > 0

        Specialty.find {_id: $in: website.specialties}, (err, specialties) ->

          getSelections = (specialty, next) ->
            getAvailableOperators {websiteId: website._id, specialtyId: specialty._id}, (err, result) ->
              return next err if err
              status = (if result.operators.length > 0 then 'chat' else 'email')
              selection = {id: specialty._id, label: "#{specialty.name} (#{status})"}

              next null, selection

          async.map specialties, getSelections, (err, selections) ->

            website.requiredFields.add
              name: 'department'
              inputType: 'selection'
              selections: selections
              label: 'Department'

            respond website.requiredFields

      else
        respond website.requiredFields
