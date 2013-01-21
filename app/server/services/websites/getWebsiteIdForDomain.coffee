db = config.require 'load/mongo'
{Website} = db.models

{getString} = config.require 'load/util'

module.exports =
  required: ['websiteUrl']
  service: ({websiteUrl}, cb) ->
    Website.findOne {url: websiteUrl}, {_id: true}, (err, site) ->
      cb err, {websiteId: getString site?._id}
