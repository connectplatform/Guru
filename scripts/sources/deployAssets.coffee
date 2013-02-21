loadAssets = config.require 'app/loadAssets'

options =
  provider: 'amazon'
  container: config.app.aws.s3_static.bucket
  accessKey: config.app.aws.accessKey
  secretKey: config.app.aws.secretKey

module.exports = ->
  loadAssets (err, rack) ->

    #@important = ['/chat.html', '/js/amd-map.js', '/js/load/index.js', '/js/config.js']
    rack.assets = (asset for asset in rack.assets when asset.url in important) if @important
    console.log "Deploying #{rack.assets.length} assets to #{options.container}."
    rack.deploy options, (err) ->
      if err
        console.log 'err:', err
      else
        console.log "Done!"
      process.exit()
