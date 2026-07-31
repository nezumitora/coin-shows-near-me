function showMatchesSearch(show, rawSearchTerm, stateAbbreviations) {
  var searchTerm = String(rawSearchTerm || '').toLowerCase().trim();
  if (!searchTerm) {
    return true;
  }

  var state = String(show.state || '').toLowerCase();
  if (stateAbbreviations && stateAbbreviations[searchTerm] === true) {
    return state === searchTerm;
  }

  var searchableFields = [
    show.name,
    show.city,
    show.stateName,
    state,
    show.venue,
    show.address
  ];

  for (var i = 0; i < searchableFields.length; i++) {
    if (String(searchableFields[i] || '').toLowerCase().indexOf(searchTerm) !== -1) {
      return true;
    }
  }

  return false;
}

function parseHomepageIsoDate(rawDate) {
  var match = String(rawDate || '').match(/^(\d{4})-(\d{2})-(\d{2})$/);
  if (!match) { return null; }
  var parsed = new Date(Number(match[1]), Number(match[2]) - 1, Number(match[3]));
  if (parsed.getFullYear() !== Number(match[1]) || parsed.getMonth() !== Number(match[2]) - 1 || parsed.getDate() !== Number(match[3])) {
    return null;
  }
  return parsed;
}

function showMatchesDateFilter(rawDates, filterName, nowValue) {
  if (!filterName || filterName === 'all') { return true; }

  var todaySource = nowValue instanceof Date ? nowValue : new Date(nowValue || Date.now());
  var today = new Date(todaySource.getFullYear(), todaySource.getMonth(), todaySource.getDate());
  var dateValues = Array.isArray(rawDates) ? rawDates : String(rawDates || '').split(',');
  var dates = dateValues.map(parseHomepageIsoDate).filter(function(date) { return date && date >= today; });

  if (filterName === 'month') {
    return dates.some(function(date) {
      return date.getFullYear() === today.getFullYear() && date.getMonth() === today.getMonth();
    });
  }

  if (filterName === 'weekend') {
    var day = today.getDay();
    var fridayOffset = day === 0 ? -2 : (day === 6 ? -1 : 5 - day);
    var friday = new Date(today.getFullYear(), today.getMonth(), today.getDate() + fridayOffset);
    var sunday = new Date(friday.getFullYear(), friday.getMonth(), friday.getDate() + 2);
    return dates.some(function(date) { return date >= friday && date <= sunday; });
  }

  return true;
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    showMatchesSearch: showMatchesSearch,
    showMatchesDateFilter: showMatchesDateFilter
  };
}
