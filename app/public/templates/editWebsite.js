define(function(){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push('<div id="editWebsite" class="modal fade small-modal"><div class="modal-header"><h3>Website Information</h3></div><form><div class="modal-body"><input'),buf.push(attrs({type:"text",value:""+website.name+"",placeholder:"Name","class":"name small-modal-box"},{type:!0,value:!0,placeholder:!0})),buf.push('/><div class="clear"></div><input'),buf.push(attrs({type:"text",value:""+website.url+"",placeholder:"URL","class":"url small-modal-box"},{type:!0,value:!0,placeholder:!0})),buf.push('/><div class="clear"></div>Specialties:<div class="specialties small-modal-box scrolling-checkboxes">'),function(){if("number"==typeof website.allowedSpecialties.length)for(var e=0,t=website.allowedSpecialties.length;e<t;e++){var n=website.allowedSpecialties[e];website.specialties.indexOf(n)==-1?(buf.push("<input"),buf.push(attrs({type:"checkbox",name:""+n+"",value:""+n+"","class":"checkbox"},{type:!0,name:!0,value:!0})),buf.push("/>")):(buf.push("<input"),buf.push(attrs({type:"checkbox",name:""+n+"",value:""+n+"",checked:"yes","class":"checkbox"},{type:!0,name:!0,value:!0,checked:!0})),buf.push("/>")),buf.push("&nbsp;\n"+escape((interp=n)==null?"":interp)+"<br/>")}else for(var e in website.allowedSpecialties){var n=website.allowedSpecialties[e];website.specialties.indexOf(n)==-1?(buf.push("<input"),buf.push(attrs({type:"checkbox",name:""+n+"",value:""+n+"","class":"checkbox"},{type:!0,name:!0,value:!0})),buf.push("/>")):(buf.push("<input"),buf.push(attrs({type:"checkbox",name:""+n+"",value:""+n+"",checked:"yes","class":"checkbox"},{type:!0,name:!0,value:!0,checked:!0})),buf.push("/>")),buf.push("&nbsp;\n"+escape((interp=n)==null?"":interp)+"<br/>")}}.call(this),buf.push('</div><div class="clear"></div><input'),buf.push(attrs({type:"text",value:""+website.acpEndpoint+"",placeholder:"ACP Endpoint (optional)","class":"acpEndpoint small-modal-box"},{type:!0,value:!0,placeholder:!0})),buf.push('/><div class="clear"></div><input'),buf.push(attrs({type:"text",value:""+website.acpApiKey+"",placeholder:"ACP API Key (optional)","class":"acpApiKey small-modal-box"},{type:!0,value:!0,placeholder:!0})),buf.push('/></div><div class="modal-footer"><button class="saveButton btn btn-primary">Save</button><button class="cancelButton btn">Cancel</button></div></form>Logo:<form><input type="file" name="logoUpload" class="logoUpload"/></form>Online Image:<form><input type="file" name="onlineUpload" class="onlineUpload"/></form>Offline:<form><input type="file" name="offlineUpload" class="offlineUpload"/></form></div>')}return buf.join("")}})