
chats = require './domain/_cache/chats'
operators = require './domain/_cache/operators'

module.exports = (cb)->
  redisClient = require('redis').createClient()
  
  redisClient.on 'ready', ->

    redis = client: redisClient
    redis.chats = chats redisClient
    redis.operators = operators redisClient

    cb redis