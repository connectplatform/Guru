process.env.GURU_PULSAR_PORT = 'DISABLED'
require '../server/initStoic'
clear = require '../server/domain/clearOldChats'

clear (err) ->
  console.log "#{new Date} - clear chats running"
  console.log err if err?
  process.exit()
