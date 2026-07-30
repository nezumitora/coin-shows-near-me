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

if (typeof module !== 'undefined' && module.exports) {
  module.exports = showMatchesSearch;
}
