(function() {

  define(function() {
    return {
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
      }
    };
  });

}).call(this);
