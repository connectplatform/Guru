#diff = new memwatch.HeapDiff()
#stats = diff.end()
#logger {getAuthedWith: stats.change.size_bytes}

process.env.GURU_PORT or= config.app.port
process.env.GURU_PULSAR_PORT = 'DISABLED'

async = require 'async'
memwatch = require 'memwatch'

h = config.require 'test/server/util/helpers'
Factory = config.require 'data/factory'
sampleData = config.require 'policy/sampleData'
logger = config.require 'lib/logger'

app = config.require 'load/app'

debug = ->

defaultOpts =
  operators: 1

target = 10
counter = 0

module.exports = (host, opts) ->
  host or= config.app.baseUrl
  opts or= '{}'
  opts = defaultOpts.merge JSON.parse(opts)

  app ->
    sampleData (err, sample) ->
      return h.logger err if err
      fooId = sample.websites.find({url: 'foo.com'})._id

      # create operators
      debug "Creating #{opts.operators} operators."
      createOp = (n, next) -> Factory.create 'operator', {websites: [fooId]}, next
      async.map [1..opts.operators], createOp, (err, operators) ->
        return h.logger err if err

        runChats = (op, next) ->

          debug "'#{op.email}' logs in."

          diff = new memwatch.HeapDiff()

          h.getAuthedWith {email: op.email, password: 'foobar'}, (err, operator, {sessionId}) ->
            return next err if err

            stats = diff.end()
            logger {getAuthedWith: stats.change.size_bytes}

            # logout
            debug "'#{op.email}' logs out."
            operator.logout {}, (err) ->
              return next err if err

              operator.destroy()

              # recurse
              if ++counter < target
                runChats op, next
              else
                next()

        async.forEach operators, runChats, (err) ->
          h.logger {err} if err
          h.logger 'Completed... Wait wha?'
          process.exit()
