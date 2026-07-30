'use strict';

const assert = require('node:assert/strict');
const test = require('node:test');
const showMatchesSearch = require('../_includes/homepage-search-match.js');

const stateAbbreviations = Object.assign(Object.create(null), {
  az: true,
  ca: true,
  in: true,
  mo: true,
  mt: true,
  or: true
});

const missouriShow = {
  name: 'Joplin Coin Club Show',
  city: 'Joplin',
  stateName: 'Missouri',
  state: 'MO',
  venue: 'Butcher Block Event Center',
  address: ''
};

test('recognized state abbreviations receive exact-state precedence', () => {
  assert.equal(showMatchesSearch(missouriShow, 'MO', stateAbbreviations), true);
  assert.equal(showMatchesSearch({ ...missouriShow, state: 'MT' }, 'MO', stateAbbreviations), false);
  assert.equal(showMatchesSearch({ ...missouriShow, name: 'Fremont Coin Show', state: 'CA' }, 'mo', stateAbbreviations), false);
});

test('partial full state names remain searchable', () => {
  const arizonaShow = { ...missouriShow, state: 'AZ', stateName: 'Arizona' };
  assert.equal(showMatchesSearch(arizonaShow, 'AZ', stateAbbreviations), true);
  assert.equal(showMatchesSearch(arizonaShow, 'Arizon', stateAbbreviations), true);
});

test('exact precedence applies across state abbreviations without hijacking other two-letter text', () => {
  assert.equal(showMatchesSearch({ ...missouriShow, state: 'CA', stateName: 'California' }, 'CA', stateAbbreviations), true);
  assert.equal(showMatchesSearch({ ...missouriShow, name: 'Oregon Trail Show', state: 'CA' }, 'OR', stateAbbreviations), false);
  assert.equal(showMatchesSearch({ ...missouriShow, city: 'St. Charles' }, 'st', stateAbbreviations), true);
});

test('name, city, venue, and address remain searchable', () => {
  assert.equal(showMatchesSearch(missouriShow, 'Joplin', stateAbbreviations), true);
  assert.equal(showMatchesSearch(missouriShow, 'Butcher Block', stateAbbreviations), true);
  assert.equal(showMatchesSearch({ ...missouriShow, address: 'One Convention Center Plaza' }, 'Convention Center Plaza', stateAbbreviations), true);
});

test('blank and unmatched queries behave predictably', () => {
  assert.equal(showMatchesSearch(missouriShow, '', stateAbbreviations), true);
  assert.equal(showMatchesSearch(missouriShow, 'not a real show', stateAbbreviations), false);
});
