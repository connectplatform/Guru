
chats = require './domain/_cache/chats'
operators = require './domain/_cache/operators'
sessions = require './domain/_cache/sessions'

module.exports = (cb)->
  redisClient = require('redis').createClient()
  
  redisClient.on 'ready', ->

    redis = client: redisClient
    redis.chats = chats redisClient
    redis.operators = operators redisClient
    redis.sessions = sessions redisClient

    cb redis