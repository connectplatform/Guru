db = config.require 'load/mongo'
{Website} = db.models

{getString} = config.require 'load/util'

module.exports =
  required: ['domain']
  service: ({domain}, cb) ->
    Website.findOne {url: domain}, {_id: true}, (err, site) ->
      cb err, getString site?._id
