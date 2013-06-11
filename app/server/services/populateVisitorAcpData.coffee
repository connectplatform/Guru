restler = require 'restler'
querystring = require 'querystring'

db = config.require 'load/mongo'
{Chat, Website} = db.models

module.exports = (accountId, chatId, referrerData) ->
  websiteUrl = referrerData?.websiteUrl
  return unless websiteUrl

  Website.findOne {accountId: accountId, url: websiteUrl}, {acpEndpoint: true, acpApiKey: true}, (err, site) ->
    if err or not site
      meta = {error: err, website: site, url: websiteUrl}
      config.log.error 'Error retrieving website in populateVisitorAcpData', meta
      return

    {acpEndpoint, acpApiKey} = site
    return unless acpEndpoint

    targetUrl = "#{acpEndpoint}?#{querystring.stringify referrerData}"
    headers = {
      'Accept': '*/*',
      'User-Agent': config.app.name
    }
    headers['Authorization'] = "Basic #{acpApiKey}" if acpApiKey
    requestOptions = {headers: headers}

    config.log.info 'sending ACP data:', {url: targetUrl, headers: headers, data: referrerData}
    restler.get(targetUrl, requestOptions).on 'complete', (acpData, response) ->
      if response?.statusCode in [200, 201]
        Chat.findById chatId, (err, chat) ->
          return err if err

          try
            chat.acpData = JSON.parse acpData
          catch err
            config.log 'Error parsing JSON string for acpData'
            return err
            
          chat.save (err) ->
            if err
              meta = {error: err, acpData: acpData, website: site}
              config.log.error 'Error setting visitor acp data in populateVisitorAcpData', meta
      else
        meta = {data: acpData, status: response?.statusCode}
        config.log.error 'received error from ACP server:', meta

          # no callback, this is fire and forget
