'use strict';

const assert = require('node:assert/strict');
const test = require('node:test');
const { coinNormalizeUrlValue } = require('../_includes/form-url-normalize.js');

test('adds https to common scheme-less public URLs', () => {
  assert.equal(coinNormalizeUrlValue('www.coinshownearme.com'), 'https://www.coinshownearme.com');
  assert.equal(coinNormalizeUrlValue('coinshownearme.com/show'), 'https://coinshownearme.com/show');
  assert.equal(coinNormalizeUrlValue(' example.org/events '), 'https://example.org/events');
});

test('preserves absolute URLs and rejects non-URL prose', () => {
  assert.equal(coinNormalizeUrlValue('https://example.org/show'), 'https://example.org/show');
  assert.equal(coinNormalizeUrlValue('http://example.org/show'), 'http://example.org/show');
  assert.equal(coinNormalizeUrlValue('not a website'), 'not a website');
  assert.equal(coinNormalizeUrlValue(''), '');
});
