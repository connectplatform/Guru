define(["jade"],function(jade){return function anonymous(locals,attrs,escape,rethrow,merge){var attrs=jade.attrs,escape=jade.escape,rethrow=jade.rethrow,merge=jade.merge,buf=[];with(locals||{}){var interp;buf.push('<div id="chat-outer-div" class="chatPage"><div id="chat-display-box" class="chat-box well"></div><form id="message-form" class="form-inline"><input type="text" value="" id="message"/><button type="submit" class="btn btn-primary">Send</button></form></div>')}return buf.join("")}})