define ["templates/treeviewParentNode", "templates/li", "templates/treeview"], (treeviewParentNode, li, treeview) ->
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
    clearInterval id for sel, id of @updating

  jsonToUl: (json) ->
    self = this

    walkJSON = (node) ->
      nodeType = $.type node
      switch nodeType

        when 'string'
          return li input: node

        when 'number', 'boolean', 'date', 'undefined', 'null'
          return li input: "#{node}"

        when 'array'
          rows = []
          rows.push self.jsonToUl element for element in node
          return rows.join ""

        when 'object'
          rows = []
          for k, v of node
            rows.push treeviewParentNode input: {parentName:k, childData: self.jsonToUl(v)}
          return rows.join ""

    result = walkJSON json
    return result

  getDomain = (url) ->
    return '' unless url
    [proto, _, domain] = url.split("/")
    domain or ''
