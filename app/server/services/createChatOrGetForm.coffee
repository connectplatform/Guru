async = require 'async'

db = config.require 'load/mongo'
{Website} = db.models

module.exports =
  service: (params, done) ->

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
        return newChat params, done

      # otherwise return additional fields required
      else
        done null, {fields: remaining}

    Website.findOne {url: params.websiteUrl}, (err, website) ->

      if err or not website
        config.log.warn 'Could not route chat due to missing website.', {error: err, params: params}
        return done 'Could not route chat due to missing website.'

      # get online status for each of the website's specialties
      if website.specialties and website.specialties.length > 0

        mapSpecialties {model: website, getter: 'getSpecialtyNames'}, (err, website) ->
          return done "Error getting specialty name: #{err}" if err

          getLabelStatus = (department, next) ->
            getAvailableOperators {websiteId: website._id, specialty: department}, (err, result) ->
              return next err if err
              status = (if result.operators.length > 0 then 'chat' else 'email')
              next null, "#{department} (#{status})"

          async.map website.specialties, getLabelStatus, (err, labels) ->

            website.requiredFields.add
              name: 'department'
              inputType: 'selection'
              selections: labels
              label: 'Department'

            #console.log 'required:', website.requiredFields
            respond website.requiredFields

      else
        respond website.requiredFields
