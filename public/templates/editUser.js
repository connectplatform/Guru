define(["jade"],function(jade){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push('<div id="editUser" class="modal fade small-modal"><div class="modal-header"><h3>User Information</h3></div><form><div class="modal-body"><input'),buf.push(attrs({type:"text",value:""+user.firstName+"",placeholder:"First Name","class":"firstName small-modal-box"},{type:!0,value:!0,placeholder:!0})),buf.push('/><div class="clear"></div><input'),buf.push(attrs({type:"text",value:""+user.lastName+"",placeholder:"Last Name","class":"lastName small-modal-box"},{type:!0,value:!0,placeholder:!0})),buf.push('/><div class="clear"></div><input'),buf.push(attrs({type:"text",value:""+user.email+"",placeholder:"email","class":"email small-modal-box"},{type:!0,value:!0,placeholder:!0})),buf.push('/><div class="clear"></div><select name="role" class="role small-modal-box">'),function(){if("number"==typeof user.allowedRoles.length)for(var e=0,t=user.allowedRoles.length;e<t;e++){var n=user.allowedRoles[e];n==user.role?(buf.push("<option"),buf.push(attrs({value:""+n+"",selected:"selected"},{value:!0,selected:!0})),buf.push(">"+escape((interp=n)==null?"":interp)+"</option>")):(buf.push("<option"),buf.push(attrs({value:""+n+""},{value:!0})),buf.push(">"+escape((interp=n)==null?"":interp)+"</option>"))}else for(var e in user.allowedRoles){var n=user.allowedRoles[e];n==user.role?(buf.push("<option"),buf.push(attrs({value:""+n+"",selected:"selected"},{value:!0,selected:!0})),buf.push(">"+escape((interp=n)==null?"":interp)+"</option>")):(buf.push("<option"),buf.push(attrs({value:""+n+""},{value:!0})),buf.push(">"+escape((interp=n)==null?"":interp)+"</option>"))}}.call(this),buf.push('</select><div class="clear"></div><!--TODO need to let you add these as a comma separated list, or something--><input'),buf.push(attrs({type:"text",value:""+user.websites+"",placeholder:"Websites","class":"websites small-modal-box"},{type:!0,value:!0,placeholder:!0})),buf.push('/><div class="clear"></div><input'),buf.push(attrs({type:"text",value:""+user.departments+"",placeholder:"Websites","class":"departments small-modal-box"},{type:!0,value:!0,placeholder:!0})),buf.push('/><div class="clear"></div></div><div class="modal-footer"><button class="saveButton btn btn-primary">Save</button><button class="cancelButton btn">Cancel</button></div></form></div>')}return buf.join("")}})