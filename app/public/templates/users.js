define(function(){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push('<div class="well"><div class="page-header"><h1>Users</h1></div><button id="addUser" class="btn">Add New User</button><table class="table table-striped"><thead><tr><th>First Name</th><th>Last Name</th><th>Email</th><th>Role</th><th>Websites</th><th>Specialties</th><th>Actions</th></tr></thead><tbody id="userTableBody">'),function(){if("number"==typeof users.length)for(var e=0,t=users.length;e<t;e++){var n=users[e];buf.push("<tr"),buf.push(attrs({userId:""+n.id+"","class":"userRow"},{userId:!0})),buf.push("><td>");var r=n.firstName;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.lastName;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.email;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.role;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.websiteNames;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.specialties;buf.push(escape(null==r?"":r)),buf.push("</td><th><a"),buf.push(attrs({userId:""+n.id+"","class":"editUser"},{userId:!0})),buf.push(">Edit</a>&nbsp;|&nbsp;<a"),buf.push(attrs({userId:""+n.id+"","class":"deleteUser"},{userId:!0})),buf.push(">Delete</a></th></tr>")}else for(var e in users){var n=users[e];buf.push("<tr"),buf.push(attrs({userId:""+n.id+"","class":"userRow"},{userId:!0})),buf.push("><td>");var r=n.firstName;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.lastName;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.email;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.role;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.websiteNames;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.specialties;buf.push(escape(null==r?"":r)),buf.push("</td><th><a"),buf.push(attrs({userId:""+n.id+"","class":"editUser"},{userId:!0})),buf.push(">Edit</a>&nbsp;|&nbsp;<a"),buf.push(attrs({userId:""+n.id+"","class":"deleteUser"},{userId:!0})),buf.push(">Delete</a></th></tr>")}}.call(this),buf.push('</tbody></table></div><div id="userModalBox"></div>')}return buf.join("")}})