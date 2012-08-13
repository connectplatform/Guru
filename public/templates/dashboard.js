define(["jade"],function(jade){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push('<div id="dashboard" class="well"><div class="page-header"><h1>Dashboard</h1></div><p class="description">Currently active chats.</p><table class="table table-striped"><thead><tr><th>Visitor</th><th>Operators</th><th>Status</th><th>Duration</th><th>Website</th><th>Department</th><th>Actions</th></tr></thead><tbody>'),function(){if("number"==typeof chats.length)for(var e=0,t=chats.length;e<t;e++){var n=chats[e];buf.push("<tr><td>");var r=n.visitor.username;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.operators;buf.push(escape(null==r?"":r)),buf.push("</td><td>"),n.relation=="invite"?buf.push('&nbsp;<span class="label label-warning">Invite</span>'):n.relation=="transfer"?buf.push('&nbsp;<span class="label label-warning">Transfer</span>'):(buf.push("<span"),buf.push(attrs({"class":"label label-"+n.statusLevel+""},{"class":!0})),buf.push(">"+escape((interp=n.status)==null?"":interp)+"</span>")),buf.push("</td><td"),buf.push(attrs({started:""+n.creationDate+"","class":"counter"},{started:!0})),buf.push("></td><td>");var r=n.visitor.website;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.visitor.department;buf.push(escape(null==r?"":r)),buf.push('</td><th><!-- different options depending on chat status or pending invites--><div class="btn-group">'),n.relation=="member"?(buf.push("<btn"),buf.push(attrs({chatId:""+n.id+"","class":"btn btn-danger leaveChat"},{chatId:!0})),buf.push(">Leave</btn>")):(n.relation=="invite"?(buf.push("<btn"),buf.push(attrs({chatId:""+n.id+"","class":"btn btn-success acceptInvite"},{chatId:!0})),buf.push(">Accept</btn>")):n.relation=="transfer"?(buf.push("<btn"),buf.push(attrs({chatId:""+n.id+"","class":"btn btn-success acceptTransfer"},{chatId:!0})),buf.push(">Assume</btn>")):n.status=="waiting"?(buf.push("<btn"),buf.push(attrs({chatId:""+n.id+"","class":"btn btn-success acceptChat"},{chatId:!0})),buf.push(">Accept</btn>")):(buf.push("<btn"),buf.push(attrs({chatId:""+n.id+"","class":"btn btn-dark joinChat"},{chatId:!0})),buf.push(">Join</btn>")),buf.push("<btn"),buf.push(attrs({chatId:""+n.id+"",watch:"true","class":"btn watchChat"},{chatId:!0,watch:!0})),buf.push(">Watch</btn>")),buf.push("</div></th></tr>")}else for(var e in chats){var n=chats[e];buf.push("<tr><td>");var r=n.visitor.username;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.operators;buf.push(escape(null==r?"":r)),buf.push("</td><td>"),n.relation=="invite"?buf.push('&nbsp;<span class="label label-warning">Invite</span>'):n.relation=="transfer"?buf.push('&nbsp;<span class="label label-warning">Transfer</span>'):(buf.push("<span"),buf.push(attrs({"class":"label label-"+n.statusLevel+""},{"class":!0})),buf.push(">"+escape((interp=n.status)==null?"":interp)+"</span>")),buf.push("</td><td"),buf.push(attrs({started:""+n.creationDate+"","class":"counter"},{started:!0})),buf.push("></td><td>");var r=n.visitor.website;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.visitor.department;buf.push(escape(null==r?"":r)),buf.push('</td><th><!-- different options depending on chat status or pending invites--><div class="btn-group">'),n.relation=="member"?(buf.push("<btn"),buf.push(attrs({chatId:""+n.id+"","class":"btn btn-danger leaveChat"},{chatId:!0})),buf.push(">Leave</btn>")):(n.relation=="invite"?(buf.push("<btn"),buf.push(attrs({chatId:""+n.id+"","class":"btn btn-success acceptInvite"},{chatId:!0})),buf.push(">Accept</btn>")):n.relation=="transfer"?(buf.push("<btn"),buf.push(attrs({chatId:""+n.id+"","class":"btn btn-success acceptTransfer"},{chatId:!0})),buf.push(">Assume</btn>")):n.status=="waiting"?(buf.push("<btn"),buf.push(attrs({chatId:""+n.id+"","class":"btn btn-success acceptChat"},{chatId:!0})),buf.push(">Accept</btn>")):(buf.push("<btn"),buf.push(attrs({chatId:""+n.id+"","class":"btn btn-dark joinChat"},{chatId:!0})),buf.push(">Join</btn>")),buf.push("<btn"),buf.push(attrs({chatId:""+n.id+"",watch:"true","class":"btn watchChat"},{chatId:!0,watch:!0})),buf.push(">Watch</btn>")),buf.push("</div></th></tr>")}}.call(this),buf.push("</tbody></table></div>")}return buf.join("")}})