
chats = require './domain/_cache/chats'

module.exports = (cb)->
  redisClient = require('redis').createClient()
  
  redisClient.on 'ready', ->

    redis = client: redisClient
    redis.chats = chats redisClient

    cb redis