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

function showMatchesDateFilter(rawDates, filterName, nowValue) {
  if (typeof showMatchesConfirmedDateFilter === 'function') {
    return showMatchesConfirmedDateFilter(rawDates, filterName, nowValue);
  }
  if (typeof module !== 'undefined' && module.exports) {
    return require('./show-date-status.js').showMatchesConfirmedDateFilter(rawDates, filterName, nowValue);
  }
  return !filterName || filterName === 'all';
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    showMatchesSearch: showMatchesSearch,
    showMatchesDateFilter: showMatchesDateFilter
  };
}
