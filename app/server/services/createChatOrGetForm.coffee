db = config.require 'load/mongo'
{Website} = db.models

newChat = config.require 'services/newChat'

module.exports = (params, done) ->

  # get required params
  Website.findOne {url: params.websiteUrl}, (err, website) ->

    # if there's no website, present a selection from available websites
    if err or not website
      config.log.warn 'Could not route chat due to missing website.', {error: err, params: params}
      return done 'Could not route chat due to missing website.'

    # check supplied params vs. required
    remaining = website.requiredFields.exclude (f) ->
      f.name in params.keys()

    # if we have everything needed, create the chat
    if remaining.isEmpty()
      #NOTE: this would seem to get around middleware, which is probably not a good thing
      return newChat params, done

    # otherwise return additional fields required
    else
      done null, {fields: remaining}
