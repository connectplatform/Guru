define(["jade"],function(jade){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push("<tr"),buf.push(attrs({userId:""+user.id+"","class":"userRow"},{userId:!0})),buf.push("><td>");var __val__=user.firstName;buf.push(escape(null==__val__?"":__val__)),buf.push("</td><td>");var __val__=user.lastName;buf.push(escape(null==__val__?"":__val__)),buf.push("</td><td>");var __val__=user.email;buf.push(escape(null==__val__?"":__val__)),buf.push("</td><td>");var __val__=user.role;buf.push(escape(null==__val__?"":__val__)),buf.push("</td><td>");var __val__=user.websites;buf.push(escape(null==__val__?"":__val__)),buf.push("</td><td>");var __val__=user.departments;buf.push(escape(null==__val__?"":__val__)),buf.push("</td><th><a"),buf.push(attrs({userId:""+user.id+"","class":"editUser"},{userId:!0})),buf.push(">Edit</a>&nbsp;|&nbsp;<a"),buf.push(attrs({userId:""+user.id+"","class":"deleteUser"},{userId:!0})),buf.push(">Delete</a></th></tr>")}return buf.join("")}})