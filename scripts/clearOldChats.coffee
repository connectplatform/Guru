require '../app/config'

process.env.GURU_PULSAR_PORT = 'DISABLED'
config.require 'load/initStoic'
clear = config.require 'services/clearOldChats'

clear (err) ->
  console.log "#{new Date} - clear chats running"
  console.log err if err?
  process.exit()
