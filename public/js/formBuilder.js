// Generated by CoffeeScript 1.3.3
(function() {

  define([], function() {
    return function(getFormFields, editingTemplate, deletingTemplate, saveService, deleteService, extraDataPacker, rowTemplate, initialElements) {
      var elements, formBuilder, getElementById, setElement,
        _this = this;
      elements = initialElements;
      getElementById = function(id) {
        var element, _i, _len;
        for (_i = 0, _len = elements.length; _i < _len; _i++) {
          element = elements[_i];
          if (element.id === id) {
            return extraDataPacker(element);
          }
        }
      };
      setElement = function(newElement) {
        var element, _i, _len;
        for (_i = 0, _len = elements.length; _i < _len; _i++) {
          element = elements[_i];
          if (element.id === newElement.id) {
            return element = extraDataPacker(newElement);
          }
        }
      };
      formBuilder = {
        userForm: function(template, user, onComplete) {
          return function(evt) {
            evt.preventDefault();
            $("#modalBox").html(template({
              user: user
            }));
            $('#editUser').modal();
            $('#editUser .saveButton').click(function(evt) {
              var fields;
              evt.preventDefault();
              fields = getFormFields();
              if (user.id != null) {
                fields.id = user.id;
              }
              return saveService(fields, function(err, savedUser) {
                onComplete(err, savedUser);
                if (err != null) {
                  return;
                }
                formBuilder.wireUpRow(savedUser.id);
                return $('#editUser').modal('hide');
              });
            });
            return $('#editUser .cancelButton').click(function(evt) {
              evt.preventDefault();
              return $('#editUser').modal('hide');
            });
          };
        },
        wireUpRow: function(id) {
          var currentUser, deleteUserClicked, editUserClicked;
          currentUser = getElementById(id);
          editUserClicked = formBuilder.userForm(editingTemplate, currentUser, function(err, savedUser) {
            if (err != null) {
              return notify.error("Error saving user: " + err);
            }
            setElement(savedUser);
            return $("#userTableBody .userRow[userId=" + currentUser.id + "]").replaceWith(rowTemplate({
              user: savedUser
            }));
          });
          deleteUserClicked = function(evt) {
            evt.preventDefault();
            currentUser = getElementById($(this).attr('userId'));
            console.log("currentUser", currentUser);
            $("#modalBox").html(deletingTemplate({
              user: currentUser
            }));
            console.log("box rendered");
            $('#deleteUser').modal();
            $('#deleteUser .deleteButton').click(function(evt) {
              evt.preventDefault();
              return deleteService(currentUser.id, function(err) {
                if (err != null) {
                  return notify.error("Error deleting user: " + err);
                }
                $("#userTableBody .userRow[userId=" + currentUser.id + "]").remove();
                return $('#deleteUser').modal('hide');
              });
            });
            return $('#deleteUser .cancelButton').click(function() {
              return $('#deleteUser').modal('hide');
            });
          };
          $("#userTableBody .userRow[userId=" + id + "] .editUser").click(editUserClicked);
          return $("#userTableBody .userRow[userId=" + id + "] .deleteUser").click(deleteUserClicked);
        },
        addElement: function(newElement, cb) {
          return function(evt) {
            return formBuilder.userForm(editingTemplate, newElement, function(err, savedElement) {
              if (!err) {
                initialElements.push(savedUser);
              }
              return cb(err, savedElement);
            });
          };
        }
      };
      return formBuilder;
    };
  });

}).call(this);
