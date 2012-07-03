mongo = require '../../server/mongo'
{digest_s} = require 'md5'
User = mongo.model 'User'

module.exports = (cb)->
  {exec} = require 'child_process'
  exec "coffee server/seed.coffee", cb