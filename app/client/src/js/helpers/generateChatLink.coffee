define ['app/config'], (config) ->
  (website) -> "<a href=\"JavaScript:void(0);\"
 onclick=\"window.open('#{config.url}#/newChat?websiteUrl=#{website.url}'
, 'Live Support', 'width=620,height=660, menubar=no,location=no,resizable=yes,scrollbars=yes,status=yes'); 
return false;\" rel=\"nofollow\">
<img border='0' title='Click for Live Support' alt='Click for Live Support' 
src='#{config.baseUrl}/chatLinkImage/#{website.id}'></a>"
