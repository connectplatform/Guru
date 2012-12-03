process.env.GURU_PULSAR_PORT = 'DISABLED'
renderTemplate = config.require 'services/templates/renderTemplate'

module.exports = (template, options) ->

  options = JSON.parse options
  html = renderTemplate template, options
  console.log html
