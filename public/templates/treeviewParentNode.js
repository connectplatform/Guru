define(function(){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push("<li>"+escape((interp=input.parentName)==null?"":interp)+"<ul>");var __val__=input.childData;buf.push(null==__val__?"":__val__),buf.push("</ul></li>")}return buf.join("")}})