(function() {

  define(['load/server', 'load/notify', 'load/util'], function(server, notify, util) {
    return function(getFormFields, editingTemplate, deletingTemplate, extraDataPacker, rowTemplate, initialElements, elementName, beforeRender, beforeSubmit) {
      var elements, formBuilder, getElementById, modelName,
        _this = this;
      if (beforeRender == null) {
        beforeRender = function(_, cb) {
          return cb({});
        };
      }
      if (beforeSubmit == null) {
        beforeSubmit = function(_, __, cb) {
          return cb();
        };
      }
      modelName = toTitle(elementName);
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
            evt.preventDefault();
            return beforeRender(element, function(beforeData) {
              var templateObject;
              templateObject = {};
              templateObject[elementName] = element;
              $("#" + elementName + "ModalBox").html(template(templateObject));
              $("#edit" + modelName).modal();
              $("#edit" + modelName + " .saveButton").click(function(evt) {
                evt.preventDefault();
                console.log('ping');
                return beforeSubmit(element, beforeData, function() {
                  var fields;
                  fields = getFormFields();
                  if (element.id != null) fields.id = element.id;
                  return server.saveModel({
                    modelName: modelName,
                    fields: fields
                  }, function(err, savedElement) {
                    if (err != null) {
                      return notify.error("Error saving element: " + err);
                    }
                    formBuilder.setElement(savedElement);
                    onComplete(err, savedElement);
                    if (err != null) return;
                    formBuilder.wireUpRow(savedElement.id);
                    return $("#edit" + modelName).modal('hide');
                  });
                });
              });
              return $("#edit" + modelName + " .cancelButton").click(function(evt) {
                evt.preventDefault();
                return $("#edit" + modelName).modal('hide');
              });
            });
          };
        },
        wireUpRow: function(id) {
          var currentElement, deleteElementClicked, editElementClicked;
          currentElement = getElementById(id);
          editElementClicked = formBuilder.elementForm(editingTemplate, currentElement, function(err, savedElement) {
            var templateObject;
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
            $("#delete" + modelName).modal();
            $("#delete" + modelName + " .deleteButton").click(function(evt) {
              evt.preventDefault();
              return server.deleteModel({
                modelId: currentElement.id,
                modelName: modelName
              }, function(err) {
                if (err != null) {
                  return notify.error("Error deleting " + elementName + ": " + err);
                }
                $("#" + elementName + "TableBody ." + elementName + "Row[" + elementName + "Id=" + currentElement.id + "]").remove();
                return $("#delete" + modelName).modal('hide');
              });
            });
            return $("#delete" + modelName + " .cancelButton").click(function() {
              return $("#delete" + modelName).modal('hide');
            });
          };
          $("#" + elementName + "TableBody ." + elementName + "Row[" + elementName + "Id=" + id + "] .edit" + modelName).click(editElementClicked);
          return $("#" + elementName + "TableBody ." + elementName + "Row[" + elementName + "Id=" + id + "] .delete" + modelName).click(deleteElementClicked);
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
