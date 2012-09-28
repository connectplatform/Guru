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
    console.log 'error retrieving website in populateVisitorAcpData: ', err if err

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
