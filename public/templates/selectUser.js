define(["jade"],function(jade){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push('<div id="selectUser" class="modal fade small-modal"><div class="modal-header"><h3>User Information</h3></div><table class="table table-striped"><thead><tr><th>Name</th><th>Actions</th></tr></thead><tbody id="userTableBody">'),function(){if("number"==typeof users.length)for(var e=0,t=users.length;e<t;e++){var n=users[e];buf.push("<tr"),buf.push(attrs({userId:""+n.id+"","class":"userRow"},{userId:!0})),buf.push("><td>");var r=n.chatName;buf.push(escape(null==r?"":r)),buf.push("</td><th><a"),buf.push(attrs({userId:""+n.id+"","class":"select"},{userId:!0})),buf.push(">Select</a></th></tr>")}else for(var e in users){var n=users[e];buf.push("<tr"),buf.push(attrs({userId:""+n.id+"","class":"userRow"},{userId:!0})),buf.push("><td>");var r=n.chatName;buf.push(escape(null==r?"":r)),buf.push("</td><th><a"),buf.push(attrs({userId:""+n.id+"","class":"select"},{userId:!0})),buf.push(">Select</a></th></tr>")}}.call(this),buf.push("</tbody></table></div>")}return buf.join("")}})