define(["jade"],function(jade){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push('<div class="well"><div class="page-header"><h1>Websites</h1></div><button id="addWebsite" class="btn">Add New Website</button><table class="table table-striped"><thead><tr><th>Name</th><th>Url</th><th>Specialties</th></tr></thead><tbody id="websiteTableBody">'),function(){if("number"==typeof websites.length)for(var e=0,t=websites.length;e<t;e++){var n=websites[e];buf.push("<tr"),buf.push(attrs({websiteId:""+n.id+"","class":"websiteRow"},{websiteId:!0})),buf.push("><td>");var r=n.name;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.url;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.specialties;buf.push(escape(null==r?"":r)),buf.push("</td><th><a"),buf.push(attrs({websiteId:""+n.id+"","class":"editWebsite"},{websiteId:!0})),buf.push(">Edit</a>&nbsp;|&nbsp;<a"),buf.push(attrs({websiteId:""+n.id+"","class":"deleteWebsite"},{websiteId:!0})),buf.push(">Delete</a></th></tr>")}else for(var e in websites){var n=websites[e];buf.push("<tr"),buf.push(attrs({websiteId:""+n.id+"","class":"websiteRow"},{websiteId:!0})),buf.push("><td>");var r=n.name;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.url;buf.push(escape(null==r?"":r)),buf.push("</td><td>");var r=n.specialties;buf.push(escape(null==r?"":r)),buf.push("</td><th><a"),buf.push(attrs({websiteId:""+n.id+"","class":"editWebsite"},{websiteId:!0})),buf.push(">Edit</a>&nbsp;|&nbsp;<a"),buf.push(attrs({websiteId:""+n.id+"","class":"deleteWebsite"},{websiteId:!0})),buf.push(">Delete</a></th></tr>")}}.call(this),buf.push('</tbody></table></div><div id="websiteModalBox"></div>')}return buf.join("")}})