restler = require 'restler'
querystring = require 'querystring'

db = config.require 'load/mongo'
{Website} = db.models

stoic = require 'stoic'
{Chat} = stoic.models

module.exports = (referrerData, chatId) ->
  websiteUrl = referrerData?.websiteUrl
  return unless websiteUrl

  Website.find {url: websiteUrl}, (err, [site]) ->
    config.log.error 'Error retrieving website in populateVisitorAcpData', {error: err, website: site, url: websiteUrl} if err

    acpEndpoint = site?.acpEndpoint
    return unless acpEndpoint
    targetUrl = "#{acpEndpoint}?#{querystring.stringify referrerData}"
    headers = {
      'Accept': '*/*',
      'User-Agent': config.app.name
    }
    headers['Authorization'] = "Basic #{site.acpApiKey}" if site.acpApiKey
    requestOptions = {headers: headers}
    restler.get(targetUrl, requestOptions).on 'success', (acpData) ->
      Chat.get(chatId).visitor.set 'acpData', acpData, (err) ->
        config.log.error 'Error setting visitor acp data in populateVisitorAcpData', {error: err, acpData: acpData, website: site} if err
