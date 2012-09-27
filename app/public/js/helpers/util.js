(function() {

  define(["templates/treeviewParentNode", "templates/li", "templates/treeview"], function(treeviewParentNode, li, treeview) {
    var getDomain;
    ({
      readableSize: function(size) {
        var i, units;
        units = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
        i = 0;
        while (size >= 1024) {
          size /= 1024;
          ++i;
        }
        return "" + (Math.floor(size.toFixed(1))) + " " + units[i];
      },
      prettySeconds: function(secs) {
        var days, hours, minutes, out, seconds;
        days = Math.floor(secs / 86400);
        hours = Math.floor((secs % 86400) / 3600);
        minutes = Math.floor(((secs % 86400) % 3600) / 60);
        seconds = ((secs % 86400) % 3600) % 60;
        out = "";
        if (days > 0) out += "" + days + " days ";
        if (hours > 0) out += "" + hours + " hours ";
        if (minutes > 0) out += "" + minutes + " minutes";
        if (seconds > 0 && days <= 0) out += " " + seconds + " seconds";
        return out;
      },
      elapsed: function(time) {
        var hrs, min, ms, remaining, sec;
        ms = new Date - new Date(time);
        hrs = Math.floor(ms / (1000 * 60 * 60));
        remaining = ms % (1000 * 60 * 60);
        min = Math.floor(remaining / (1000 * 60));
        remaining = ms % (1000 * 60);
        sec = Math.floor(remaining / 1000);
        return {
          hours: hrs,
          minutes: min,
          seconds: sec
        };
      },
      elapsedDisplay: function(time) {
        var e, hours;
        e = this.elapsed(time);
        hours = hours > 0 ? "" + e.hours + "h : " : "";
        return "" + hours + e.minutes + "m : " + e.seconds + "s";
      },
      autotimer: function(selector) {
        var id, updateCounters,
          _this = this;
        if (this.updating == null) this.updating = {};
        if (this.updating[selector]) return;
        updateCounters = function() {
          return $(selector).each(function(_, item) {
            return $(item).html(_this.elapsedDisplay($(item).attr('started')));
          });
        };
        updateCounters();
        id = setInterval(updateCounters, 1000);
        return this.updating[selector] = id;
      },
      cleartimers: function() {
        var id, sel, _ref, _results;
        _ref = this.updating;
        _results = [];
        for (sel in _ref) {
          id = _ref[sel];
          _results.push(clearInterval(id));
        }
        return _results;
      },
      jsonToUl: function(json) {
        var result, self, walkJSON;
        self = this;
        walkJSON = function(node) {
          var element, k, nodeType, rows, v, _i, _len;
          nodeType = $.type(node);
          switch (nodeType) {
            case 'string':
              return li({
                input: node
              });
            case 'number':
            case 'boolean':
            case 'date':
            case 'undefined':
            case 'null':
              return li({
                input: "" + node
              });
            case 'array':
              rows = [];
              for (_i = 0, _len = node.length; _i < _len; _i++) {
                element = node[_i];
                rows.push(self.jsonToUl(element));
              }
              return rows.join("");
            case 'object':
              rows = [];
              for (k in node) {
                v = node[k];
                rows.push(treeviewParentNode({
                  input: {
                    parentName: k,
                    childData: self.jsonToUl(v)
                  }
                }));
              }
              return rows.join("");
          }
        };
        result = walkJSON(json);
        return result;
      }
    });
    return getDomain = function(url) {
      var domain, proto, _, _ref;
      if (!url) return '';
      _ref = url.split("/"), proto = _ref[0], _ = _ref[1], domain = _ref[2];
      return domain || '';
    };
  });

}).call(this);
