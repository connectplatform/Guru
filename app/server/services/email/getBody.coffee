fs = require 'fs'
path = require 'path'
jade = require 'jade'

# load in email templates
templPath = config.path 'views/emailTemplates'
templates = {}
for file in fs.readdirSync templPath
  templates[path.basename file, '.jade'] = path.join templPath, file

module.exports = (template, options, done) ->
  jade.renderFile templates[template], options, done
