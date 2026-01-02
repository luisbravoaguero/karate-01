/*function fn() {

  function pad2(n) { return (n < 10 ? '0' : '') + n; }

  // Create a date from yyyy-MM-dd in UTC to avoid timezone flakiness
  function parseIso(iso) {
    var parts = iso.split('-').map(x => parseInt(x, 10));
    return new Date(Date.UTC(parts[0], parts[1] - 1, parts[2], 12, 0, 0));
  }

  function addDays(dateObj, days) {
    return new Date(dateObj.getTime() + days * 24 * 60 * 60 * 1000);
  }

  function format(dateObj, pattern) {
    var y = dateObj.getUTCFullYear();
    var m = pad2(dateObj.getUTCMonth() + 1);
    var d = pad2(dateObj.getUTCDate());

    if (pattern === 'yyyy-MM-dd') return y + '-' + m + '-' + d;
    if (pattern === 'dd/MM/yyyy') return d + '/' + m + '/' + y;
    if (pattern === 'yyyyMMdd') return '' + y + m + d;

    // default
    return y + '-' + m + '-' + d;
  }

  // Enterprise-friendly: build a controlled range + derived values
  function range(args) {
    var startObj = parseIso(args.start);
    var endObj = parseIso(args.end);

    var plusDays = args.plusDays || 0;
    var derivedObj = addDays(startObj, plusDays);

    var pattern = args.pattern || 'yyyy-MM-dd';

    return {
      startObj: startObj,
      endObj: endObj,
      derivedObj: derivedObj,
      start: format(startObj, pattern),
      end: format(endObj, pattern),
      derived: format(derivedObj, pattern)
    };
  }

  return {
    parseIso: parseIso,
    addDays: addDays,
    format: format,
    range: range
  };
}
*/

function fn() {

  // Use Java time (reliable for months)
  var LocalDate = Java.type('java.time.LocalDate');
  var DateTimeFormatter = Java.type('java.time.format.DateTimeFormatter');

  // ---------------------------
  // "Private" helper functions
  // ---------------------------
    function todayLocalDate() {
      return LocalDate.now();
    }
  function parseIsoDateString(isoDate) {
    // isoDate example: "2026-01-01"
    return LocalDate.parse(isoDate); // ISO-8601 by default
  }

  function addDaysToLocalDate(localDate, daysToAdd) {
    return localDate.plusDays(daysToAdd);
  }

  function addMonthsToLocalDate(localDate, monthsToAdd) {
    return localDate.plusMonths(monthsToAdd);
  }

  function formatLocalDate(localDate, pattern) {
    // Works with patterns like:
    // "yyyy-MM-dd", "dd/MM/yyyy", "yyyyMMdd", etc.
    var fmt = DateTimeFormatter.ofPattern(pattern);
    return localDate.format(fmt);
  }

  // ---------------------------
  // "Public" main function
  // ---------------------------

  function buildDateRange(args) {
    // args example:
    // {
    //   start: "2026-01-01",
    //   end: "2026-12-31",
    //   pattern: "yyyy-MM-dd",
    //   plusDays: 10,
    //   plusMonths: 2
    // }

    var startIso = args.start;
    var endIso = args.end;

    var pattern = args.pattern || 'yyyy-MM-dd';
    var plusDays = args.plusDays || 0;
    var plusMonths = args.plusMonths || 0;

    var startObj = parseIsoDateString(startIso);
    var endObj = parseIsoDateString(endIso);

    // Derived = start + months + days (both supported)
    var derivedObj = startObj;
    if (plusMonths !== 0) derivedObj = addMonthsToLocalDate(derivedObj, plusMonths);
    if (plusDays !== 0) derivedObj = addDaysToLocalDate(derivedObj, plusDays);

    return {
      // "Obj" values are LocalDate now (even better than JS Date)
      startObj: startObj,
      endObj: endObj,
      derivedObj: derivedObj,

      // formatted strings used in request/response
      start: formatLocalDate(startObj, pattern),
      end: formatLocalDate(endObj, pattern),
      derived: formatLocalDate(derivedObj, pattern)
    };
  }

  // ---------------------------
  // Exported functions (public API)
  // ---------------------------
    return {
      parseIso: parseIsoDateString,
      addDays: addDaysToLocalDate,
      addMonths: addMonthsToLocalDate,
      format: formatLocalDate,
      range: buildDateRange,
      today: todayLocalDate
    };

}
