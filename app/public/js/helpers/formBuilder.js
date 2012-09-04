(function() {

  define(["load/server"], function(server) {
    return function(getFormFields, editingTemplate, deletingTemplate, extraDataPacker, rowTemplate, initialElements, elementName) {
      var elements, formBuilder, getElementById, uppercaseName,
        _this = this;
      uppercaseName = elementName.charAt(0).toUpperCase() + elementName.slice(1);
      elements = initialElements;
      getElementById = function(id) {
        var element, _i, _len;
        for (_i = 0, _len = elements.length; _i < _len; _i++) {
          element = elements[_i];
          if (element.id === id) return extraDataPacker(element);
        }
      };
      formBuilder = {
        elementForm: function(template, element, onComplete) {
          return function(evt) {
            var templateObject;
            evt.preventDefault();
            templateObject = {};
            templateObject[elementName] = element;
            $("#" + elementName + "ModalBox").html(template(templateObject));
            $("#edit" + uppercaseName).modal();
            $("#edit" + uppercaseName + " .saveButton").click(function(evt) {
              var fields;
              evt.preventDefault();
              fields = getFormFields();
              if (element.id != null) fields.id = element.id;
              return server.saveModel(fields, uppercaseName, function(err, savedElement) {
                formBuilder.setElement(savedElement);
                onComplete(err, savedElement);
                if (err != null) return;
                formBuilder.wireUpRow(savedElement.id);
                return $("#edit" + uppercaseName).modal('hide');
              });
            });
            return $("#edit" + uppercaseName + " .cancelButton").click(function(evt) {
              evt.preventDefault();
              return $("#edit" + uppercaseName).modal('hide');
            });
          };
        },
        wireUpRow: function(id) {
          var currentElement, deleteElementClicked, editElementClicked;
          currentElement = getElementById(id);
          editElementClicked = formBuilder.elementForm(editingTemplate, currentElement, function(err, savedElement) {
            var templateObject;
            if (err != null) return notify.error("Error saving element: " + err);
            templateObject = {};
            templateObject[elementName] = savedElement;
            return $("#" + elementName + "TableBody ." + elementName + "Row[" + elementName + "Id=" + currentElement.id + "]").replaceWith(rowTemplate(templateObject));
          });
          deleteElementClicked = function(evt) {
            var templateObject;
            evt.preventDefault();
            currentElement = getElementById($(this).attr("" + elementName + "Id"));
            templateObject = {};
            templateObject[elementName] = currentElement;
            $("#" + elementName + "ModalBox").html(deletingTemplate(templateObject));
            $("#delete" + uppercaseName).modal();
            $("#delete" + uppercaseName + " .deleteButton").click(function(evt) {
              evt.preventDefault();
              return server.deleteModel(currentElement.id, uppercaseName, function(err) {
                if (err != null) {
                  return notify.error("Error deleting " + elementName + ": " + err);
                }
                $("#" + elementName + "TableBody ." + elementName + "Row[" + elementName + "Id=" + currentElement.id + "]").remove();
                return $("#delete" + uppercaseName).modal('hide');
              });
            });
            return $("#delete" + uppercaseName + " .cancelButton").click(function() {
              return $("#delete" + uppercaseName).modal('hide');
            });
          };
          $("#" + elementName + "TableBody ." + elementName + "Row[" + elementName + "Id=" + id + "] .edit" + uppercaseName).click(editElementClicked);
          return $("#" + elementName + "TableBody ." + elementName + "Row[" + elementName + "Id=" + id + "] .delete" + uppercaseName).click(deleteElementClicked);
        },
        addElement: function(newElement, cb) {
          return function(evt) {
            return formBuilder.elementForm(editingTemplate, newElement, function(err, savedElement) {
              if (!err) initialElements.push(savedElement);
              return cb(err, savedElement);
            });
          };
        },
        setElement: function(newElement) {
          var element, _i, _len;
          for (_i = 0, _len = elements.length; _i < _len; _i++) {
            element = elements[_i];
            if (element.id === newElement.id) {
              return elements[elements.indexOf(element)] = extraDataPacker(newElement);
            }
          }
          return elements.push(newElement);
        }
      };
      return formBuilder;
    };
  });

}).call(this);
