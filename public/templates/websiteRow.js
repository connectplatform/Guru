define(["jade"],function(jade){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push("<tr"),buf.push(attrs({websiteId:""+website.id+"","class":"websiteRow"},{websiteId:!0})),buf.push("><td>");var __val__=website.name;buf.push(escape(null==__val__?"":__val__)),buf.push("</td><td>");var __val__=website.url;buf.push(escape(null==__val__?"":__val__)),buf.push("</td><th><a"),buf.push(attrs({websiteId:""+website.id+"","class":"editWebsite"},{websiteId:!0})),buf.push(">Edit</a>&nbsp;|&nbsp;<a"),buf.push(attrs({websiteId:""+website.id+"","class":"deleteWebsite"},{websiteId:!0})),buf.push(">Delete</a></th></tr>")}return buf.join("")}})