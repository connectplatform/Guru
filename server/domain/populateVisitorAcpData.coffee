restler = require 'restler'
querystring = require 'querystring'
db = require '../mongo'
{Website} = db.models

redgoose = require 'redgoose'
{Chat} = redgoose.models

module.exports = (referrerData, chatId) ->
  websiteUrl = referrerData?.websiteUrl
  return unless websiteUrl

  Website.find {url: websiteUrl}, (err, [site]) ->
    console.log 'error retrieving website in populateVisitorAcpData: ', err if err

    acpEndpoint = site?.acpEndpoint
    return unless acpEndpoint
    targetUrl = "#{acpEndpoint}?#{querystring.stringify referrerData}"
    restler.get(targetUrl).on 'complete', (acpData) ->
      Chat.get(chatId).visitor.set 'acpData', acpData, (err) ->
