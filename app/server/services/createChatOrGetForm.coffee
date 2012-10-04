db = config.require 'load/mongo'
{Website} = db.models

newChat = config.require 'services/newChat'

module.exports = (res, params) ->

  # get required params
  Website.findOne {name: params.websiteUrl}, (err, website) ->
    if err or not website
      err ?= "Could not find website."
      console.log err
      return res.reply err

    # check supplied params vs. required
    remaining = website.requiredFields.exclude (f) ->
      f.name in params.keys()

    # if we have everything needed, create the chat
    if remaining.isEmpty()
      #NOTE: this would seem to get around middleware, which is probably not a good thing
      return newChat res, params

    # otherwise return additional fields required
    else
      res.reply null, {fields: remaining}
