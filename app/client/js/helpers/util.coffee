define ["templates/treeviewParentNode", "templates/li", "templates/treeview"], (treeviewParentNode, li, treeview) ->
  getType: (obj) -> Object.prototype.toString.call(obj).slice 8, -1
  toTitle: (word) ->
    word[0].toUpperCase() + word.slice(1)

  append: (selector, message) ->
    $(selector).append message
    @scrollToBottom selector

  scrollToBottom: (selector) ->
    $(selector).scrollTop($(selector).height())

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

        when 'array'
          rows = ['<ul>']
          rows.push self.jsonToUl element for element in node
          rows.push '</ul>'
          return rows.join ""

        when 'object'
          rows = ['<ul>']
          for k, v of node
            rows.push treeviewParentNode parentName:k, childData: self.jsonToUl(v)
          rows.push '</ul>'
          return rows.join ""

        when 'undefined', 'null'
          return ''

        else
          return node.toString()


    result = walkJSON json
    return result

  getDomain: (url) ->
    return '' unless url
    [proto, _, domain] = url.split("/")
    domain or ''

  random: ->
    digit = -> ((Math.random() * 16) | 0).toString 16
    buffer = []
    for n in [1..16]
      buffer.push digit()

    return buffer.join ''
