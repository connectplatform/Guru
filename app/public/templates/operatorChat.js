define(function(){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push('<div class="well"><ul id="chatTabs" class="nav nav-tabs">'),function(){if("number"==typeof chats.length)for(var e=0,t=chats.length;e<t;e++){var n=chats[e];buf.push("<li><a"),buf.push(attrs({href:"#"+n.renderedId+"",chatid:""+n.renderedId+"","data-toggle":"tab"},{href:!0,chatid:!0,"data-toggle":!0})),buf.push('><span class="chatTab">'+escape((interp=n.visitor.username)==null?"":interp)+"</span><span"),buf.push(attrs({chatid:""+n.renderedId+"","class":"notifyUnread"},{chatid:!0})),buf.push("></span></a></li>")}else for(var e in chats){var n=chats[e];buf.push("<li><a"),buf.push(attrs({href:"#"+n.renderedId+"",chatid:""+n.renderedId+"","data-toggle":"tab"},{href:!0,chatid:!0,"data-toggle":!0})),buf.push('><span class="chatTab">'+escape((interp=n.visitor.username)==null?"":interp)+"</span><span"),buf.push(attrs({chatid:""+n.renderedId+"","class":"notifyUnread"},{chatid:!0})),buf.push("></span></a></li>")}}.call(this),buf.push('</ul><div class="tab-content">'),function(){if("number"==typeof chats.length)for(var e=0,t=chats.length;e<t;e++){var n=chats[e];buf.push("<div"),buf.push(attrs({id:""+n.renderedId+"","class":"tab-pane row operatorChat"},{id:!0})),buf.push("><div"),buf.push(attrs({chatId:""+n.id+"","class":"chatWindow span8 row"},{chatId:!0})),buf.push('><div class="chat-box well chat-display-box span12">'),function(){if("number"==typeof n.history.length)for(var e=0,t=n.history.length;e<t;e++){var r=n.history[e];buf.push("<p>"+escape((interp=r.username)==null?"":interp)+": "+escape((interp=r.message)==null?"":interp)+"</p>")}else for(var e in n.history){var r=n.history[e];buf.push("<p>"+escape((interp=r.username)==null?"":interp)+": "+escape((interp=r.message)==null?"":interp)+"</p>")}}.call(this),buf.push('</div><form class="message-form form-inline"><input type="text" value="" class="message"/><button type="submit" class="btn btn-primary submit-button">Send</button></form></div><div'),buf.push(attrs({chatId:""+n.id+"","class":"well chatControls span4"},{chatId:!0})),buf.push('><div class="visitor-info"><div class="websiteLogo"></div><strong>Visitor:</strong> '+escape((interp=n.visitor.username)==null?"":interp)+"<br/><strong>Website:</strong> "+escape((interp=n.website)==null?"":interp)+'<div class="acp-data"><strong>ACP Data:</strong>');if(n.visitor.acpData){buf.push("<ul"),buf.push(attrs({id:"acpTree"+n.renderedId+"","class":"treeview"},{id:!0,"class":!0})),buf.push(">");var r=n.visitor.acpData;buf.push(null==r?"":r),buf.push("</ul>")}else buf.push('<div class="clear"></div>No data availible');buf.push('</div></div><div class="actions"><table><tr><td><button class="btn btn-primary printButton">Print</button></td><td><button class="btn btn-primary emailButton">Email</button></td><td><button class="btn btn-danger kickButton">Kick</button></td></tr><tr><td><button class="btn btn-primary inviteButton">Invite</button></td><td><button class="btn btn-primary transferButton">Transfer</button></td><td><button class="btn btn-warning leaveButton">Leave</button></td></tr></table></div></div></div>')}else for(var e in chats){var n=chats[e];buf.push("<div"),buf.push(attrs({id:""+n.renderedId+"","class":"tab-pane row operatorChat"},{id:!0})),buf.push("><div"),buf.push(attrs({chatId:""+n.id+"","class":"chatWindow span8 row"},{chatId:!0})),buf.push('><div class="chat-box well chat-display-box span12">'),function(){if("number"==typeof n.history.length)for(var e=0,t=n.history.length;e<t;e++){var r=n.history[e];buf.push("<p>"+escape((interp=r.username)==null?"":interp)+": "+escape((interp=r.message)==null?"":interp)+"</p>")}else for(var e in n.history){var r=n.history[e];buf.push("<p>"+escape((interp=r.username)==null?"":interp)+": "+escape((interp=r.message)==null?"":interp)+"</p>")}}.call(this),buf.push('</div><form class="message-form form-inline"><input type="text" value="" class="message"/><button type="submit" class="btn btn-primary submit-button">Send</button></form></div><div'),buf.push(attrs({chatId:""+n.id+"","class":"well chatControls span4"},{chatId:!0})),buf.push('><div class="visitor-info"><div class="websiteLogo"></div><strong>Visitor:</strong> '+escape((interp=n.visitor.username)==null?"":interp)+"<br/><strong>Website:</strong> "+escape((interp=n.website)==null?"":interp)+'<div class="acp-data"><strong>ACP Data:</strong>');if(n.visitor.acpData){buf.push("<ul"),buf.push(attrs({id:"acpTree"+n.renderedId+"","class":"treeview"},{id:!0,"class":!0})),buf.push(">");var r=n.visitor.acpData;buf.push(null==r?"":r),buf.push("</ul>")}else buf.push('<div class="clear"></div>No data availible');buf.push('</div></div><div class="actions"><table><tr><td><button class="btn btn-primary printButton">Print</button></td><td><button class="btn btn-primary emailButton">Email</button></td><td><button class="btn btn-danger kickButton">Kick</button></td></tr><tr><td><button class="btn btn-primary inviteButton">Invite</button></td><td><button class="btn btn-primary transferButton">Transfer</button></td><td><button class="btn btn-warning leaveButton">Leave</button></td></tr></table></div></div></div>')}}.call(this),buf.push('</div></div><div id="selectModal"></div>')}return buf.join("")}})