module.exports = ->
  config.require('load/initServices')()
  clear = config.require 'services/clearOldChats'
  clear (err) ->
    console.log "#{new Date} - clear chats running"
    console.log err if err?
    process.exit()
