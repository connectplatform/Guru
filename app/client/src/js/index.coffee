require.config {
  map:
    "*":
      "vendor/dermis": "dermis",
      "vendor/pulsar": "pulsar",
      "vendor/vein": "vein",
      "vendor/jquery": "jquery"
}

define ["require", "app/config"], (require, config) ->
  (configFileUrl) ->
    Object.extend()

    success = () ->
      require ["load/shim", "load/main"], () ->

    error = ->
      console.log("error")

    config.configure(configFileUrl).then success, error