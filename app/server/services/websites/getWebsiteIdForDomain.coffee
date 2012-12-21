db = config.require 'load/mongo'
{Website} = db.models

{getString} = config.require 'load/util'

module.exports =
  required: ['websiteUrl']
  service: ({websiteUrl}, cb) ->
    Website.findOne {url: websiteUrl}, {_id: true}, (err, site) ->
      cb err, getString site?._id
