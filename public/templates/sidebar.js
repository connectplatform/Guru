define(function(){return function anonymous(locals,attrs,escape,rethrow,merge){attrs=attrs||jade.attrs,escape=escape||jade.escape,rethrow=rethrow||jade.rethrow,merge=merge||jade.merge;var buf=[];with(locals||{}){var interp;buf.push('<div class="well sidebar-nav"><ul class="nav nav-list"><li class="nav-header">Operator</li><li><a href="#/dashboard"><i class="icon-home"></i>Dashboard</a><span class="notifyUnanswered"></span></li><li><a href="#/operatorChat"><i class="img-chat"></i>My Chats</a><span class="notifyUnread"></span></li><li><a href="#/userAdmin"><i class="icon-user"></i>My Profile</a></li><li><a href="#/logout"><i class="icon-off"></i>Logout</a></li>'),role=="Administrator"&&buf.push('<li class="nav-header">Admin</li><li><a href="#/users"><i class="icon-user"></i>Users</a></li><li><a href="#/websites"><i class="icon-list-alt"></i>Websites</a></li><li><a href="#/specialties"><i class="icon-tag"></i>Specialties</a></li>'),buf.push("</ul></div>")}return buf.join("")}})