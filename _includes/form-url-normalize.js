function coinNormalizeUrlValue(rawValue) {
  var value = String(rawValue || '').trim();
  if (!value || /^[a-z][a-z0-9+.-]*:\/\//i.test(value)) {
    return value;
  }

  if (/^(?:www\.)?[a-z0-9](?:[a-z0-9.-]*[a-z0-9])?\.[a-z]{2,}(?::\d+)?(?:[/?#].*)?$/i.test(value)) {
    return 'https://' + value;
  }

  return value;
}

function coinNormalizeFormUrls(form) {
  if (!form) { return; }
  var urlFields = form.querySelectorAll('input[type="url"]');
  Array.prototype.forEach.call(urlFields, function(field) {
    field.value = coinNormalizeUrlValue(field.value);
  });
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    coinNormalizeUrlValue: coinNormalizeUrlValue
  };
}
