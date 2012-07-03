chats = require './domain/_cache/chats'
operators = require './domain/_cache/operators'
sessions = require './domain/_cache/sessions'

redisClient = require('redis').createClient()

redis = client: redisClient
redis.chats = chats redisClient
redis.operators = operators redisClient
redis.sessions = sessions redisClient

module.exports = redis