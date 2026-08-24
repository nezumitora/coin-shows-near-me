(function(root, factory) {
  var api = factory();
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = api;
  } else {
    Object.keys(api).forEach(function(key) { root[key] = api[key]; });
  }
})(typeof globalThis !== 'undefined' ? globalThis : this, function() {
  'use strict';

  function parseShowIsoDate(rawDate) {
    var match = String(rawDate || '').match(/^(\d{4})-(\d{2})-(\d{2})$/);
    if (!match) { return null; }
    var parsed = new Date(Number(match[1]), Number(match[2]) - 1, Number(match[3]));
    if (parsed.getFullYear() !== Number(match[1]) || parsed.getMonth() !== Number(match[2]) - 1 || parsed.getDate() !== Number(match[3])) {
      return null;
    }
    parsed.setHours(0, 0, 0, 0);
    return parsed;
  }

  function confirmedShowDates(rawDates) {
    var values = Array.isArray(rawDates) ? rawDates : String(rawDates || '').split(',');
    var seen = Object.create(null);
    var dates = [];
    for (var index = 0; index < values.length; index++) {
      var parsed = parseShowIsoDate(values[index]);
      if (!parsed) { continue; }
      var key = parsed.getFullYear() + '-' + String(parsed.getMonth() + 1).padStart(2, '0') + '-' + String(parsed.getDate()).padStart(2, '0');
      if (seen[key]) { continue; }
      seen[key] = true;
      dates.push(parsed);
    }
    return dates.sort(function(left, right) { return left.getTime() - right.getTime(); });
  }

  function groupShowDateRanges(rawDates) {
    var dates = confirmedShowDates(rawDates);
    var ranges = [];
    for (var index = 0; index < dates.length; index++) {
      var date = dates[index];
      var lastRange = ranges[ranges.length - 1];
      var nextCalendarDay = lastRange ? new Date(lastRange.end.getFullYear(), lastRange.end.getMonth(), lastRange.end.getDate() + 1) : null;
      if (!lastRange || date.getTime() !== nextCalendarDay.getTime()) {
        ranges.push({ start: date, end: date });
      } else {
        lastRange.end = date;
      }
    }
    return ranges;
  }

  function monthDay(date) {
    return date.toLocaleDateString('en-US', { month: 'long', day: 'numeric' });
  }

  function formatShowDateRange(range) {
    var start = range.start;
    var end = range.end;
    if (start.getTime() === end.getTime()) {
      return start.toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' });
    }
    if (start.getFullYear() === end.getFullYear() && start.getMonth() === end.getMonth()) {
      return monthDay(start) + '-' + end.getDate() + ', ' + end.getFullYear();
    }
    if (start.getFullYear() === end.getFullYear()) {
      return monthDay(start) + '-' + monthDay(end) + ', ' + end.getFullYear();
    }
    return start.toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' }) + '-' +
      end.toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' });
  }

  function classifyShowDates(rawDates, options) {
    var settings = options || {};
    var todaySource = settings.now instanceof Date ? settings.now : new Date(settings.now || Date.now());
    var today = new Date(todaySource.getFullYear(), todaySource.getMonth(), todaySource.getDate());
    var ranges = groupShowDateRanges(rawDates);
    var activeRange = null;
    for (var index = 0; index < ranges.length; index++) {
      if (ranges[index].end >= today) {
        activeRange = ranges[index];
        break;
      }
    }

    if (activeRange) {
      return {
        key: 'scheduled',
        label: 'Scheduled',
        description: 'A confirmed event range ends today or later; verify before traveling.',
        displayDate: formatShowDateRange(activeRange),
        lastConfirmedDate: null,
        range: activeRange
      };
    }

    if (ranges.length > 0) {
      var lastRange = ranges[ranges.length - 1];
      var ended = settings.seriesEnded === true;
      return {
        key: ended ? 'past-show' : 'past-date-unconfirmed',
        label: ended ? 'Past show' : 'Past date — next date unconfirmed',
        description: ended ? 'This nonrecurring show has ended.' : 'The known occurrence passed; no later date is confirmed.',
        displayDate: null,
        lastConfirmedDate: formatShowDateRange(lastRange),
        range: null
      };
    }

    return {
      key: 'date-not-confirmed',
      label: 'Date not confirmed',
      description: 'No future date is confirmed.',
      displayDate: null,
      lastConfirmedDate: null,
      range: null
    };
  }

  function showDateRangesOverlap(rawDates, startDate, endDate) {
    return firstShowDateRangeOverlapping(rawDates, startDate, endDate) !== null;
  }

  function firstShowDateRangeOverlapping(rawDates, startDate, endDate) {
    var ranges = groupShowDateRanges(rawDates);
    for (var index = 0; index < ranges.length; index++) {
      if (ranges[index].start <= endDate && ranges[index].end >= startDate) {
        return ranges[index];
      }
    }
    return null;
  }

  function showWeekendWindow(nowValue) {
    var source = nowValue instanceof Date ? nowValue : new Date(nowValue || Date.now());
    var today = new Date(source.getFullYear(), source.getMonth(), source.getDate());
    var saturdayOffset = today.getDay() === 0 ? -1 : 6 - today.getDay();
    var saturday = new Date(today.getFullYear(), today.getMonth(), today.getDate() + saturdayOffset);
    var sunday = new Date(saturday.getFullYear(), saturday.getMonth(), saturday.getDate() + 1);
    return { start: saturday, end: sunday };
  }

  function firstShowWeekendRangeBetween(rawDates, startDate, endDate) {
    var ranges = groupShowDateRanges(rawDates);
    for (var rangeIndex = 0; rangeIndex < ranges.length; rangeIndex++) {
      var range = ranges[rangeIndex];
      var cursor = range.start > startDate ? new Date(range.start) : new Date(startDate);
      var limit = range.end < endDate ? range.end : endDate;
      while (cursor <= limit) {
        if (cursor.getDay() === 0 || cursor.getDay() === 6) { return range; }
        cursor = new Date(cursor.getFullYear(), cursor.getMonth(), cursor.getDate() + 1);
      }
    }
    return null;
  }

  function showMatchesConfirmedDateFilter(rawDates, filterName, nowValue) {
    if (!filterName || filterName === 'all') { return true; }

    var source = nowValue instanceof Date ? nowValue : new Date(nowValue || Date.now());
    var today = new Date(source.getFullYear(), source.getMonth(), source.getDate());
    if (filterName === 'weekend') {
      var weekend = showWeekendWindow(today);
      return showDateRangesOverlap(rawDates, weekend.start, weekend.end);
    }
    if (filterName === 'month') {
      var monthEnd = new Date(today.getFullYear(), today.getMonth() + 1, 0);
      return showDateRangesOverlap(rawDates, today, monthEnd);
    }
    return true;
  }

  function hydrateShowDateRecords(scope, nowValue) {
    if (!scope || !scope.querySelectorAll) { return; }
    var records = scope.querySelectorAll('[data-show-date-record]');
    for (var index = 0; index < records.length; index++) {
      var record = records[index];
      var result = classifyShowDates(record.getAttribute('data-confirmed-dates'), {
        now: nowValue,
        seriesEnded: record.getAttribute('data-series-ended') === 'true'
      });
      record.setAttribute('data-date-status', result.key);

      var displays = record.querySelectorAll('[data-show-date-display]');
      for (var displayIndex = 0; displayIndex < displays.length; displayIndex++) {
        displays[displayIndex].textContent = result.displayDate || '';
        displays[displayIndex].hidden = !result.displayDate;
      }

      var statuses = record.querySelectorAll('[data-show-date-status]');
      for (var statusIndex = 0; statusIndex < statuses.length; statusIndex++) {
        statuses[statusIndex].textContent = result.label;
        statuses[statusIndex].className = 'trust-status trust-status--' + result.key;
      }

      var descriptions = record.querySelectorAll('[data-show-date-description]');
      for (var descriptionIndex = 0; descriptionIndex < descriptions.length; descriptionIndex++) {
        descriptions[descriptionIndex].textContent = result.description;
      }

      var nextDates = record.querySelectorAll('[data-show-next-date]');
      for (var nextIndex = 0; nextIndex < nextDates.length; nextIndex++) {
        nextDates[nextIndex].textContent = result.displayDate || result.label;
      }

      var lastDates = record.querySelectorAll('[data-show-last-confirmed]');
      for (var lastIndex = 0; lastIndex < lastDates.length; lastIndex++) {
        lastDates[lastIndex].textContent = result.lastConfirmedDate ? 'Last confirmed occurrence: ' + result.lastConfirmedDate : '';
        lastDates[lastIndex].hidden = !result.lastConfirmedDate;
      }
    }
  }

  if (typeof document !== 'undefined') {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', function() { hydrateShowDateRecords(document, new Date()); });
    } else {
      hydrateShowDateRecords(document, new Date());
    }
  }

  return {
    parseShowIsoDate: parseShowIsoDate,
    confirmedShowDates: confirmedShowDates,
    groupShowDateRanges: groupShowDateRanges,
    formatShowDateRange: formatShowDateRange,
    classifyShowDates: classifyShowDates,
    showDateRangesOverlap: showDateRangesOverlap,
    firstShowDateRangeOverlapping: firstShowDateRangeOverlapping,
    showWeekendWindow: showWeekendWindow,
    firstShowWeekendRangeBetween: firstShowWeekendRangeBetween,
    showMatchesConfirmedDateFilter: showMatchesConfirmedDateFilter,
    hydrateShowDateRecords: hydrateShowDateRecords
  };
});
