/*
 * Date Format 1.2.3
 * (c) 2007-2009 Steven Levithan <stevenlevithan.com>
 * MIT license
 *
 * Includes enhancements by Scott Trenda <scott.trenda.net>
 * and Kris Kowal <cixar.com/~kris.kowal/>
 *
 * Accepts a date, a mask, or a date and a mask.
 * Returns a formatted version of the given date.
 * The date defaults to the current date/time.
 * The mask defaults to dateFormat.masks.default.
 */
// For todays date;
Date.prototype.today = function() {
  return new Date().format(window.ServerDateFormat);
  //return (((this.getMonth() + 1) < 10) ? "0" : "") + (this.getMonth() + 1) + "/" + ((this.getDate() < 10) ? "0" : "") + this.getDate() + "/" + this.getFullYear();
};

// For the time now
Date.prototype.timeNow = function() {
  return (
    (this.getHours() < 10 ? "0" : "") +
    this.getHours() +
    ":" +
    (this.getMinutes() < 10 ? "0" : "") +
    this.getMinutes() +
    ":" +
    (this.getSeconds() < 10 ? "0" : "") +
    this.getSeconds()
  );
};

var dateFormat = (function() {
  var token = /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g,
    timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g,
    timezoneClip = /[^-+\dA-Z]/g,
    pad = function(val, len) {
      val = String(val);
      len = len || 2;
      while (val.length < len) val = "0" + val;
      return val;
    };

  // Regexes and supporting functions are cached through closure
  return function(date, mask, utc) {
    var dF = dateFormat;

    // You can't provide utc if you skip other args (use the "UTC:" mask prefix)
    if (
      arguments.length === 1 &&
      Object.prototype.toString.call(date) === "[object String]" &&
      !/\d/.test(date)
    ) {
      mask = date;
      date = undefined;
    }

    // Passing date through Date applies Date.parse, if necessary
    date = date ? new Date(date) : new Date();
    if (isNaN(date)) throw SyntaxError("invalid date");

    mask = String(dF.masks[mask] || mask || dF.masks["default"]);

    // Allow setting the utc argument via the mask
    if (mask.slice(0, 4) === "UTC:") {
      mask = mask.slice(4);
      utc = true;
    }

    var _ = utc ? "getUTC" : "get",
      d = date[_ + "Date"](),
      D = date[_ + "Day"](),
      m = date[_ + "Month"](),
      y = date[_ + "FullYear"](),
      H = date[_ + "Hours"](),
      M = date[_ + "Minutes"](),
      s = date[_ + "Seconds"](),
      L = date[_ + "Milliseconds"](),
      o = utc ? 0 : date.getTimezoneOffset(),
      flags = {
        d: d,
        dd: pad(d),
        ddd: dF.i18n.dayNames[D],
        dddd: dF.i18n.dayNames[D + 7],
        m: m + 1,
        mm: pad(m + 1),
        mmm: dF.i18n.monthNames[m],
        mmmm: dF.i18n.monthNames[m + 12],
        yy: String(y).slice(2),
        yyyy: y,
        h: H % 12 || 12,
        hh: pad(H % 12 || 12),
        H: H,
        HH: pad(H),
        M: M,
        MM: pad(M),
        s: s,
        ss: pad(s),
        l: pad(L, 3),
        L: pad(L > 99 ? Math.round(L / 10) : L),
        t: H < 12 ? "a" : "p",
        tt: H < 12 ? "am" : "pm",
        T: H < 12 ? "A" : "P",
        TT: H < 12 ? "AM" : "PM",
        Z: utc
          ? "UTC"
          : (String(date).match(timezone) || [""])
              .pop()
              .replace(timezoneClip, ""),
        o:
          (o > 0 ? "-" : "+") +
          pad(Math.floor(Math.abs(o) / 60) * 100 + (Math.abs(o) % 60), 4),
        S: ["th", "st", "nd", "rd"][
          d % 10 > 3 ? 0 : (((d % 100) - (d % 10) !== 10) * d) % 10
        ]
      };

    return mask.replace(token, function($0) {
      return $0 in flags ? flags[$0] : $0.slice(1, $0.length - 1);
    });
  };
})();

// Some common format strings
dateFormat.masks = {
  default: "ddd mmm dd yyyy HH:MM:ss",
  shortDate: "m/d/yy",
  mediumDate: "mmm d, yyyy",
  longDate: "mmmm d, yyyy",
  fullDate: "dddd, mmmm d, yyyy",
  shortTime: "h:MM TT",
  mediumTime: "h:MM:ss TT",
  longTime: "h:MM:ss TT Z",
  isoDate: "yyyy-mm-dd",
  isoTime: "HH:MM:ss",
  isoDateTime: "yyyy-mm-dd'T'HH:MM:ss",
  isoUtcDateTime: "UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"
};

// Internationalization strings
dateFormat.i18n = {
  dayNames: [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ],
  monthNames: [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ]
};

// For convenience...
Date.prototype.format = function(mask, utc) {
  return dateFormat(this, mask, utc);
};

function GetDateTimeDifference(earlierDate, laterDate) {
  var oDiff = new Object();

  //  Calculate Differences
  //  -------------------------------------------------------------------  //
  var nTotalDiff = laterDate.getTime() - earlierDate.getTime();

  oDiff.days = Math.floor(nTotalDiff / 1000 / 60 / 60 / 24);
  nTotalDiff -= oDiff.days * 1000 * 60 * 60 * 24;

  oDiff.hours = Math.floor(nTotalDiff / 1000 / 60 / 60);
  nTotalDiff -= oDiff.hours * 1000 * 60 * 60;

  oDiff.minutes = Math.floor(nTotalDiff / 1000 / 60);
  nTotalDiff -= oDiff.minutes * 1000 * 60;

  oDiff.seconds = Math.floor(nTotalDiff / 1000);
  //  -------------------------------------------------------------------  //

  //  Format Duration
  //  -------------------------------------------------------------------  //
  //  Format Hours
  var hourtext = "00";
  if (oDiff.days > 0) {
    hourtext = String(oDiff.days);
  }
  if (hourtext.length == 1) {
    hourtext = "0" + hourtext;
  }

  //  Format Minutes
  var mintext = "00";
  if (oDiff.minutes > 0) {
    mintext = String(oDiff.minutes);
  }
  if (mintext.length == 1) {
    mintext = "0" + mintext;
  }

  //  Format Seconds
  var sectext = "00";
  if (oDiff.seconds > 0) {
    sectext = String(oDiff.seconds);
  }
  if (sectext.length == 1) {
    sectext = "0" + sectext;
  }

  //  Set Duration
  var sDuration = hourtext + ":" + mintext + ":" + sectext;
  oDiff.duration = sDuration;
  //  -------------------------------------------------------------------  //

  return oDiff;
}
function datediff(fromDate, toDate, interval) {
  /*
   * DateFormat month/day/year hh:mm:ss
   * ex.
   * datediff('01/01/2011 12:00:00','01/01/2011 13:30:00','seconds');
   */
  var second = 1000,
    minute = second * 60,
    hour = minute * 60,
    day = hour * 24,
    week = day * 7;
  fromDate = new Date(fromDate);
  toDate = new Date(toDate);
  var timediff = toDate - fromDate;
  if (isNaN(timediff)) return NaN;
  switch (interval) {
    case "years":
      return toDate.getFullYear() - fromDate.getFullYear();
    case "months":
      return (
        toDate.getFullYear() * 12 +
        toDate.getMonth() -
        (fromDate.getFullYear() * 12 + fromDate.getMonth())
      );
    case "weeks":
      return Math.floor(timediff / week);
    case "days":
      return Math.floor(timediff / day);
    case "hours":
      return Math.floor(timediff / hour);
    case "minutes":
      return Math.floor(timediff / minute);
    case "seconds":
      return Math.floor(timediff / second);
    default:
      return undefined;
  }
}

String.prototype.toDate = function(format) {
  var normalized = this.replace(/[^a-zA-Z0-9]/g, "-");
  var normalizedFormat = format.toLowerCase().replace(/[^a-zA-Z0-9]/g, "-");
  var formatItems = normalizedFormat.split("-");
  var dateItems = normalized.split("-");

  var monthIndex = formatItems.indexOf("m");
  if (monthIndex === -1) monthIndex = formatItems.indexOf("mm");
  var dayIndex = formatItems.indexOf("d");
  if (dayIndex === -1) dayIndex = formatItems.indexOf("dd");
  var yearIndex = formatItems.indexOf("yy");
  if (yearIndex === -1) yearIndex = formatItems.indexOf("yyyy");

  var today = new Date();

  var year = yearIndex > -1 ? dateItems[yearIndex] : today.getFullYear();
  var month =
    monthIndex > -1 ? dateItems[monthIndex] - 1 : today.getMonth() - 1;
  var day = dayIndex > -1 ? dateItems[dayIndex] : today.getDate();

  return new Date(year, month, day, 0, 0, 0);
};

Date.isLeapYear = function(year) {
  return (year % 4 === 0 && year % 100 !== 0) || year % 400 === 0;
};

Date.getDaysInMonth = function(year, month) {
  return [
    31,
    Date.isLeapYear(year) ? 29 : 28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ][month];
};

Date.prototype.isLeapYear = function() {
  return Date.isLeapYear(this.getFullYear());
};

Date.prototype.getDaysInMonth = function() {
  return Date.getDaysInMonth(this.getFullYear(), this.getMonth());
};

Date.prototype.addMonths = function(value) {
  var n = this.getDate();
  this.setDate(1);
  this.setMonth(this.getMonth() + value);
  this.setDate(Math.min(n, this.getDaysInMonth()));
  return this;
};
