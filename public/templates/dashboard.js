define(["jade"],function(jade){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push('<div id="home" class="well"><div class="page-header"><h1>Dashboard</h1></div><p class="description">Currently active chats.</p><table class="table table-striped"><thead><tr><th>Visitor</th><th>Visitor Present</th><th>Operators</th><th>Duration</th><!--th Creation Date--><th>Website</th><th>Department</th><th>Actions</th></tr></thead><tbody>'),function(){if("number"==typeof chats.length)for(var e=0,t=chats.length;e<t;e++){var n=chats[e];buf.push("<tr><td>");var r=n.visitor.username;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.visitorPresent;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.operators;buf.push(escape(null==r?"":r)),buf.push("</td><td"),buf.push(attrs({started:""+n.creationDate+"","class":"counter"},{started:!0})),buf.push("></td><!--td= chat.creationDate--><td>");var r=n.visitor.website;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.visitor.department;buf.push(escape(null==r?"":r)),buf.push("</td><td><a"),buf.push(attrs({href:"#/joinChat/"+n.id+""},{href:!0})),buf.push(">Join</a>&nbsp;|&nbsp;<a"),buf.push(attrs({href:"#/joinChat/"+n.id+"?watch=true"},{href:!0})),buf.push(">Watch</a></td></tr>")}else for(var e in chats){var n=chats[e];buf.push("<tr><td>");var r=n.visitor.username;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.visitorPresent;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.operators;buf.push(escape(null==r?"":r)),buf.push("</td><td"),buf.push(attrs({started:""+n.creationDate+"","class":"counter"},{started:!0})),buf.push("></td><!--td= chat.creationDate--><td>");var r=n.visitor.website;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.visitor.department;buf.push(escape(null==r?"":r)),buf.push("</td><td><a"),buf.push(attrs({href:"#/joinChat/"+n.id+""},{href:!0})),buf.push(">Join</a>&nbsp;|&nbsp;<a"),buf.push(attrs({href:"#/joinChat/"+n.id+"?watch=true"},{href:!0})),buf.push(">Watch</a></td></tr>")}}.call(this),buf.push("</tbody></table></div>")}return buf.join("")}})