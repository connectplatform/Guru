define(["jade"],function(jade){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push('<div id="login-modal" class="modal fade small-modal"><div class="modal-header"><h3>Login</h3></div><form id="login-form"><div class="modal-body"><input id="email" type="text" placeholder="Email" value="" class="small-modal-box"/><div class="clear"></div><input id="password" type="password" placeholder="Password" value="" class="small-modal-box"/></div><div class="modal-footer"><button type="submit" class="btn btn-primary">Login</button><button id="login-cancel-button" class="btn">Cancel</button></div></form></div>')}return buf.join("")}})