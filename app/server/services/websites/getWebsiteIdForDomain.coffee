mongo = config.require 'server/load/mongo'
{Website} = mongo.models

module.exports = (websiteDomain, cb) ->

  siteIds = {}
  Website.find {}, (err, websites) ->
    siteIds[website.url] = website._id for website in websites
    cb siteIds[websiteDomain]
