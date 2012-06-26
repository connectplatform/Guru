define ->
  readableSize: (size) ->
    units = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
    i = 0
    while size >= 1024
      size /= 1024
      ++i
    return "#{Math.floor(size.toFixed(1))} #{units[i]}"

  prettySeconds: (secs) ->
    days = Math.floor secs / 86400
    hours = Math.floor (secs % 86400) / 3600
    minutes = Math.floor ((secs % 86400) % 3600) / 60
    seconds = ((secs % 86400) % 3600) % 60
    out = ""
    out += "#{days} days " if days > 0
    out += "#{hours} hours " if hours > 0
    out += "#{minutes} minutes" if minutes > 0
    out += " #{seconds} seconds" if seconds > 0 and days <= 0
    return out

  elapsed: (time) ->
    ms = new Date - new Date time

    hrs = Math.floor(ms / (1000 * 60 * 60))
    remaining = ms % (1000 * 60 * 60)

    min = Math.floor(remaining / (1000 * 60))
    remaining = ms % (1000 * 60)

    sec = Math.floor(remaining / 1000)
    {hours: hrs, minutes: min, seconds: sec}

  elapsedDisplay: (time) ->
    e = @elapsed time
    hours = if hours > 0 then "#{e.hours}h : " else ""
    "#{hours}#{e.minutes}m : #{e.seconds}s"

  autotimer: (selector) ->
    @updating ?= {}
    return if @updating[selector]

    updateCounters = => $(selector).each (_, item) =>
      $(item).html @elapsedDisplay($(item).attr 'started')

    updateCounters()
    id = setInterval updateCounters, 1000
    @updating[selector] = id

  cleartimers: ->
    console.log "clearing: ", @updating
    clearInterval id for sel, id of @updating
