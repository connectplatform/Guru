chats = require './domain/_cache/chats'

redisClient = require('redis').createClient()

redis = client: redisClient
redis.chats = chats redisClient

module.exports = redis