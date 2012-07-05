chats = require './domain/_cache/chats'
sessions = require './domain/_cache/sessions'

redisClient = require('redis').createClient()

redis = client: redisClient
redis.chats = chats redisClient
redis.sessions = sessions redisClient

module.exports = redis