'use strict';

const assert = require('node:assert/strict');
const test = require('node:test');
const {
  classifyShowDates,
  firstShowDateRangeOverlapping,
  firstShowWeekendRangeBetween,
  formatShowDateRange,
  groupShowDateRanges,
  parseShowIsoDate,
  showMatchesConfirmedDateFilter,
  showWeekendWindow
} = require('../_includes/show-date-status.js');

test('strict ISO parsing rejects invalid or incomplete dates', () => {
  assert.equal(parseShowIsoDate('2026-08-23').getDate(), 23);
  assert.equal(parseShowIsoDate('2026-02-30'), null);
  assert.equal(parseShowIsoDate('August 23, 2026'), null);
});

test('classification uses range end and explicit ended state', () => {
  const sunday = new Date(2026, 7, 23, 12, 0, 0);
  const active = classifyShowDates(['2026-08-22', '2026-08-23'], { now: sunday });
  const recurringPast = classifyShowDates(['2026-08-09'], { now: sunday });
  const ended = classifyShowDates(['2026-08-09'], { now: sunday, seriesEnded: true });
  const unknown = classifyShowDates([], { now: sunday });

  assert.equal(active.label, 'Scheduled');
  assert.equal(active.displayDate, 'August 22-23, 2026');
  assert.equal(recurringPast.label, 'Past date — next date unconfirmed');
  assert.equal(ended.label, 'Past show');
  assert.equal(unknown.label, 'Date not confirmed');
});

test('date ranges group consecutive calendar days and expose overlaps', () => {
  const ranges = groupShowDateRanges(['2026-08-23', '2026-08-22', '2026-09-13']);
  const weekendRange = firstShowDateRangeOverlapping(
    ['2026-08-22', '2026-08-23', '2026-09-13'],
    new Date(2026, 7, 22),
    new Date(2026, 7, 23)
  );

  assert.equal(ranges.length, 2);
  assert.equal(formatShowDateRange(ranges[0]), 'August 22-23, 2026');
  assert.equal(formatShowDateRange(weekendRange), 'August 22-23, 2026');
});

test('weekend helpers use Saturday and Sunday, never Friday alone', () => {
  const sunday = new Date(2026, 7, 23, 12, 0, 0);
  const window = showWeekendWindow(sunday);

  assert.equal(window.start.getDate(), 22);
  assert.equal(window.end.getDate(), 23);
  assert.equal(showMatchesConfirmedDateFilter(['2026-08-21'], 'weekend', sunday), false);
  assert.equal(showMatchesConfirmedDateFilter(['2026-08-21', '2026-08-22'], 'weekend', sunday), true);
  assert.equal(showMatchesConfirmedDateFilter(['2026-08-09'], 'weekend', sunday), false);
});

test('next-30-day helper requires at least one Saturday or Sunday overlap', () => {
  const start = new Date(2026, 7, 24);
  const end = new Date(2026, 8, 22);

  assert.equal(firstShowWeekendRangeBetween(['2026-08-28'], start, end), null);
  assert.equal(formatShowDateRange(firstShowWeekendRangeBetween(['2026-08-28', '2026-08-29'], start, end)), 'August 28-29, 2026');
});
