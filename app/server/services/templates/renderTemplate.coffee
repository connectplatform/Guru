fs = require 'fs'
path = require 'path'
jade = require 'jade'

templPath = config.path 'views'
templates = {}

for file in fs.readdirSync templPath
  templateText = fs.readFileSync path.join(templPath, file), 'UTF8'
  templates[path.basename file, '.jade'] = jade.compile templateText

module.exports = ({template, options}) ->
  console.log '[renderTemplate]'.yellow, {template, options}
  templates[template] options
