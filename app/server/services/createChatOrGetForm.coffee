db = config.require 'load/mongo'
{Website} = db.models

newChat = config.require 'services/newChat'

module.exports = (res, params) ->

  # get required params
  Website.findOne {name: params.websiteUrl}, (err, website) ->

    # if there's no website, present a selection from available websites
    if err or not website
      console.log "Error finding website:", err if err
      return Website.find {}, {url: true}, (err, allWebsites) ->
        console.log 'allWebsites:', allWebsites
        domains = (w.url for w in allWebsites)
        res.reply err, fields: [
          name: 'website'
          label: 'Website'
          inputType: 'selection'
          selections: domains
        ]

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
