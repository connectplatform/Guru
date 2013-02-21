{basename} = require 'path'
{Rack, StaticAssets} = require 'asset-rack'
hashUrls = require './hashUrls'

genUrl = (base) -> "/guru-test/#{base}"
getPath = (file) -> __dirname + "/../client/#{file}"

autoLoad = (path) ->
  [
      new StaticAssets {
        urlPrefix: "/"
        hash: false
        filter: (path) -> basename(path).match /\.html$/
        dirname: config.path path
      }
      new StaticAssets {
        urlPrefix: "/"
        hash: true
        filter: (path) -> not (basename(path).match /\.html$/)
        dirname: config.path path
      }
  ]

# grab all our compiled public assets
assets = autoLoad 'public'

# if we have marketing pages, grab them too
if config.paths.static
  assets.push autoLoad('static')...

rack = new Rack assets

module.exports = (done) ->
  rack.ready ->

    options =
      paths: [
        {name: "templates", location: "templates"}
        {name: "middleware", location: "js/policy/middleware"}
        {name: "policy", location: "js/policy"}
        {name: "load", location: "js/load"}
        {name: "helpers", location: "js/helpers"}
        {name: "routes", location: "js/routes"}
        {name: "vendor", location: "js/vendor"}
        {name: "app", location: "js"}
      ]

    # map base URLs to hashed versions for AMD
    rack.addAmdRack options, (err, amdRack) ->
      #amdRack.contents = amdRack.contents.replace /js\//g, 'app/'

      # replace ALL urls in static assets with their hashed versions
      hashUrls rack

      done null, rack
