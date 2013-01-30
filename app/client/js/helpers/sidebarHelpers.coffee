unreadMessages = {}

define ['templates/badge'], (badge) ->
  helpers =
    countUnreadMessages: (unread) ->
      total = 0
      for chat, count of unread
        total += count
      total

    playSound: (type) ->
      $("##{type}Sound")[0].play()

    updateBadge: (selector, num, status='important') ->
      content = if num > 0 then badge {status: status, num: num} else ''
      $(selector).html content

    updateUnread: (unread, chime) ->
      unreadMessages = helpers.countUnreadMessages unread
      helpers.updateBadge "#sidebar .notifyUnread", unreadMessages
      helpers.playSound "newMessage" if chime is 'true'

    readChat: (chatId) ->
      unreadMessages[chatId] = 0
      helpers.updateUnread unreadMessages

  return helpers
