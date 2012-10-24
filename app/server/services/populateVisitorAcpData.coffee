restler = require 'restler'
querystring = require 'querystring'

db = config.require 'load/mongo'
{Website} = db.models

stoic = require 'stoic'
{Chat} = stoic.models

module.exports = (accountId, chatId, referrerData) ->
  websiteUrl = referrerData?.websiteUrl
  return unless websiteUrl

  Website.findOne {accountId: accountId, url: websiteUrl}, {acpEndpoint: true, acpApiKey: true}, (err, site) ->
    if err
      meta = {error: err, website: site, url: websiteUrl}
      config.log.error 'Error retrieving website in populateVisitorAcpData', meta

    {acpEndpoint, acpApiKey} = site
    return unless acpEndpoint

    targetUrl = "#{acpEndpoint}?#{querystring.stringify referrerData}"
    headers = {
      'Accept': '*/*',
      'User-Agent': config.app.name
    }
    headers['Authorization'] = "Basic #{acpApiKey}" if acpApiKey
    requestOptions = {headers: headers}

    restler.get(targetUrl, requestOptions).on 'success', (acpData) ->
      Chat(accountId).get(chatId).visitor.set 'acpData', acpData, (err) ->
        if err
          meta = {error: err, acpData: acpData, website: site}
          config.log.error 'Error setting visitor acp data in populateVisitorAcpData', meta

        # no callback, this is fire and forget
