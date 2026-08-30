'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');
const { showMatchesSearch, showMatchesDateFilter } = require('../_includes/homepage-search-match.js');

const statesYaml = fs.readFileSync(path.join(__dirname, '../_data/states.yml'), 'utf8');
const stateCodes = Array.from(statesYaml.matchAll(/^- abbrev: ([A-Z]{2})$/gm), (match) => match[1]);
const stateAbbreviations = Object.create(null);
for (const stateCode of stateCodes) {
  stateAbbreviations[stateCode.toLowerCase()] = true;
}

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

test('all 50 state abbreviations receive exact-state precedence', () => {
  assert.equal(stateCodes.length, 50);
  assert.equal(new Set(stateCodes).size, 50);

  for (const stateCode of stateCodes) {
    const otherState = stateCode === 'AL' ? 'AK' : 'AL';
    const matchingShow = { ...missouriShow, state: stateCode };
    const distractingShow = { ...missouriShow, name: `${stateCode} appears in this name`, state: otherState };

    assert.equal(showMatchesSearch(matchingShow, stateCode, stateAbbreviations), true, `${stateCode} should match its state`);
    assert.equal(showMatchesSearch(matchingShow, stateCode.toLowerCase(), stateAbbreviations), true, `${stateCode} should match lowercase input`);
    assert.equal(showMatchesSearch(distractingShow, stateCode, stateAbbreviations), false, `${stateCode} should not match text in another state`);
  }
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

test('date filters match this weekend and the current month using ISO dates', () => {
  const friday = new Date(2026, 6, 31, 12, 0, 0);

  assert.equal(showMatchesDateFilter('2026-07-31,2026-08-01', 'weekend', friday), true);
  assert.equal(showMatchesDateFilter('2026-07-31', 'weekend', friday), false);
  assert.equal(showMatchesDateFilter('2026-08-07', 'weekend', friday), false);
  assert.equal(showMatchesDateFilter('2026-07-31,2026-08-01', 'month', friday), true);
  assert.equal(showMatchesDateFilter('2026-08-01', 'month', friday), false);
});

test('weekend filter includes the current Saturday and Sunday', () => {
  const saturday = new Date(2026, 7, 1, 12, 0, 0);
  const sunday = new Date(2026, 7, 2, 12, 0, 0);

  assert.equal(showMatchesDateFilter('2026-08-01', 'weekend', saturday), true);
  assert.equal(showMatchesDateFilter('2026-08-02', 'weekend', sunday), true);
  assert.equal(showMatchesDateFilter('', 'weekend', saturday), false);
  assert.equal(showMatchesDateFilter('', 'all', saturday), true);
});

test('frozen August 23 weekend includes only Saturday or Sunday overlaps', () => {
  const sunday = new Date(2026, 7, 23, 12, 0, 0);

  assert.equal(showMatchesDateFilter('2026-08-09', 'weekend', sunday), false);
  assert.equal(showMatchesDateFilter('2026-08-22,2026-08-23', 'weekend', sunday), true);
  assert.equal(showMatchesDateFilter('2026-08-23', 'weekend', sunday), true);
  assert.equal(showMatchesDateFilter('2026-08-21', 'weekend', sunday), false);
  assert.equal(showMatchesDateFilter('2026-08-21,2026-08-22', 'weekend', sunday), true);
});
