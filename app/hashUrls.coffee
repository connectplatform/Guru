webtypes = ['application/javascript', 'text/javascript', 'text/html', 'text/css']

module.exports = (assets) ->

  replaceUrls = (content) ->
    result = content.toString()
    for asset in assets.assets when asset.url and asset.specificUrl
      #console.log "replacing: #{asset.url} with: #{asset.specificUrl}"
      pattern = new RegExp asset.url, 'g'
      result = result.replace pattern, asset.specificUrl
    return result

  for asset in assets.assets when asset.mimetype in webtypes and asset.url isnt '/js/amd-map.js'
    asset.contents = replaceUrls asset.contents
    #console.log "result for #{asset.url}:", asset.contents if asset.url is '/foo.html'
