{inspect} = require 'util'
loadAssets = config.require 'app/loadAssets'

module.exports = ->
  loadAssets (err, rack) ->
    console.log 'static assets:\n  ', rack.assets.map( (a)->inspect {url: a.url, specific: a.specificUrl} ).join '\n  '
    #console.log 'asset-map:', asset.contents for asset in rack.assets when asset.url is '/js/amd-map.js'
    #console.log 'chat.html:', asset.contents for asset in rack.assets when asset.url is '/chat.html'
    #console.log 'bootstrap.min.css:', asset.contents for asset in rack.assets when asset.url is '/css/vendor/bootstrap.min.css'
