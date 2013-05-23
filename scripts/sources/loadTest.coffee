process.env.GURU_PORT or= config.app.port
process.env.GURU_PULSAR_PORT = 'DISABLED'

async = require 'async'
{memdiff, noop, changeFormat} = config.require 'lib/memdiff'
changeFormat 'details'

h = config.require 'test/util/helpers'
Factory = config.require 'data/factory'
sampleData = config.require 'policy/sampleData'
logger = config.require 'lib/logger'

# load app internally or reference an external instance
if process.env.APART
  init = config.require 'load/initStoic'
  config.require('load/initServices')()
  memdiff = noop
else
  init = config.require 'load/app'

debug = logger

opts =
  iterations: 1
  operators: 1
  minChats: 40
  maxChats: 40
  delay: 1

message = 'accept chat worked'
counter = 0

module.exports = (args...) ->
  {iterations, minChats, maxChats, delay} = opts

  init ->
    sampleData (err, sample) ->
      return h.logger err if err
      fooId = sample.websites.find({url: 'foo.com'})._id
      accountId = sample.accounts.find({accountType: 'Unlimited'})._id

      # create operators
      debug "Creating #{opts.operators} operators."
      createOp = (n, next) -> Factory.create 'operator', {websites: [fooId]}, next
      async.map [1..opts.operators], createOp, (err, operators) ->
        return h.logger err if err

        runChats = (op, next) ->

          # pick a random number between minChats and maxChats
          chatTarget = Math.floor(minChats + (Math.random() * (maxChats - minChats)))

          debug "Operator '#{op.email}' logs in."
          h.getAuthedWith {email: op.email, password: 'foobar'}, (err, operator, {sessionId}) ->
            return next err if err

            debug "Visitor requests chat."
            h.newVisitor {websiteUrl: 'foo.com'}, (err, visitor, data) ->
              return next err if err
              {chatId} = data

              debug "Operator '#{op.email}' accepts chat '#{chatId}'."
              operator.acceptChat {chatId, accountId}, (err, result) =>
                return next err if err

                #chan = h.getPulsar().channel chatId

                #chan.once 'serverMessage', (data) ->
                  #data.message.should.eql message
                  #done()

                # send test chats
                debug "Sending #{chatTarget} test chats."
                iterator = (next) ->
                  startTime = new Date

                  operator.say {accountId, chatId, message}, (err) ->
                  #operator.printChat {sessionId, chatId}, (err) ->
                  #h.newVisitor {websiteUrl: 'foo.com'}, (err, visitor, data) ->

                    return next err if err
                    h.logger "Chat sent in #{startTime.millisecondsAgo()} ms."
                    setTimeout next, delay

                check = -> chatTarget-- > 0

                async.whilst check, iterator, (err) ->
                  return next err if err

                  # logout
                  debug "Logging out visitor, operator '#{op.email}'."
                  visitor.leaveChat {accountId, chatId}, (err) ->
                    return next err if err
                    operator.logout {accountId}, (err) ->
                      return next err if err

                      visitor.destroy()
                      operator.destroy()

                      # recurse
                      if not iterations or (++counter < iterations)
                        runChats op, next
                      else
                        next()

        memdiff 'no vein', async.forEach, operators, runChats, (err) ->

          h.logger {err} if err
          h.logger 'Completed!'
          process.exit()
