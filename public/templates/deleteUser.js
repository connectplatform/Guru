define(["jade"],function(jade){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push('<div id="deleteUser" class="modal fade small-modal"><div class="modal-header"><h3>Delete User</h3><div class="modal-body">Are you sure you want to delete user '+escape((interp=user.email)==null?"":interp)+'?</div><div class="modal-footer"><button class="deleteButton btn">Delete</button><button class="cancelButton btn btn-primary">Cancel</button></div></div></div>')}return buf.join("")}})