define(function(){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push("<div"),buf.push(attrs({chatId:""+chat.id+"","class":"well chatControls span4"},{chatId:!0})),buf.push('><div class="websiteLogo"></div><div class="visitor-info">Visitor: '+escape((interp=chat.visitor.username)==null?"":interp)+"<br/>Website: "+escape((interp=chat.website)==null?"":interp)+'<div class="acp-data">ACP Data:');if(chat.visitor.acpData){buf.push("<ul"),buf.push(attrs({id:"acpTree"+chat.renderedId+"","class":"treeview"},{id:!0,"class":!0})),buf.push(">");var __val__=chat.visitor.acpData;buf.push(null==__val__?"":__val__),buf.push("</ul>")}else buf.push('<div class="clear"></div>No data availible');buf.push('</div></div><div class="actions"><p>Actions:</p><table><tr><td><button class="btn btn-primary printButton">Print</button></td><td><button class="btn btn-primary emailButton">Email</button></td></tr><tr><td><button class="btn btn-primary inviteButton">Invite</button></td><td><button class="btn btn-primary transferButton">Transfer</button></td></tr><tr><td><button class="btn btn-danger kickButton">Kick</button></td><td><button class="btn btn-warning leaveButton">Leave</button></td></tr></table></div></div>')}return buf.join("")}})