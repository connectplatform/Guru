allTestFiles = []

TEST_REGEXP = /spec\.js$/

KARMA_CONF_BASE_URL = "./"

pathToModule = (path) ->
  path.replace(/^\/base\//, '').replace(/\.js/, '')

Object.keys(window.__karma__.files).forEach (file) ->
  if TEST_REGEXP.test(file)
    allTestFiles.push(pathToModule(file))

require.config {
  baseUrl: "/base/#{KARMA_CONF_BASE_URL}"

  paths:
    "app": "app/client/js"
    "load": "app/client/js/load"
    "policy": "app/client/js/policy"
    "routes": "app/client/js/routes"
    "helpers": "app/client/js/helpers"
    "vein": "app/client/js/vendor/vein"
    "pulsar": "app/client/js/vendor/pulsar"
    "templates": ".tmp/templates"
    "jade": "app/client/vendor/jade_runtime/index"
    "spec": "test/client/spec"

  deps: allTestFiles

  callback: window.__karma__.start
}

# sugar.js
Object.extend()