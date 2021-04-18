import 'dart:core';

import 'package:rztime/rztime.dart';
import 'package:test/test.dart';

void main() {
  test('findMax', () {
    expect(
        maxDateTime([
          null,
          DateTime(2014, 5, 1),
          DateTime(2011, 5, 1),
          DateTime(2019, 5, 1),
          null,
          DateTime(2017, 5, 1),
        ]),
        DateTime(2019, 5, 1));

    expect(maxDateTime([null, null, null]), null);

    expect(maxDateTime([]), null);
  });

  test('roundToSecond', () {
    expect(DateTime(2021, 1, 1, 22, 36, 15, 499, 999).roundToSeconds(),
        DateTime(2021, 1, 1, 22, 36, 15));
    expect(DateTime(2021, 1, 1, 22, 36, 15, 500, 000).roundToSeconds(),
        DateTime(2021, 1, 1, 22, 36, 16));
    expect(DateTime(2021, 1, 1, 22, 36, 15, 500, 000).floorToSecond(),
        DateTime(2021, 1, 1, 22, 36, 15));
  });

  test('sinceDayStart', () {
    expect(DateTime(2021, 1, 1, 22, 36, 15, 499, 999).durationSinceDayStart(),
        Duration(hours: 22, minutes: 36, seconds: 15, microseconds: 499999));
    expect(DateTime(2021, 1, 1, 0, 5, 15, 499, 999).durationSinceDayStart().inSeconds, 315);
  });

  test('randomTimeBetween within millisecond', () {
    final a = DateTime.now();
    final b = DateTime.now().add(Duration(milliseconds: 1));

    Set<DateTime> results = Set<DateTime>();

    for (int i = 0; i <= 1000; ++i) {
      final r = randomTimeBetween(a, b);
      expect(r.isAfter(a) || r.isAtSameMomentAs(a), isTrue);
      expect(r.isBefore(b), isTrue);
      results.add(r);
    }

    expect(results.length, greaterThan(10));
  });

  test('randomTimeBetween one microsecond', () {
    final a = DateTime.now();
    final b = DateTime.now().add(Duration(microseconds: 1));

    Set<DateTime> results = <DateTime>{};

    for (int i = 0; i <= 1000; ++i) {
      final r = randomTimeBetween(a, b);
      expect(r.isAfter(a) || r.isAtSameMomentAs(a), isTrue);
      expect(r.isBefore(b), isTrue);
      results.add(r);
    }

    expect(results.length, 1, reason: results.toString()); // ровно один результат, потому что интервал 1 миллисекунда
  });

  test('randomTimeBetween exotic cases', () {
    final a = DateTime.now();
    final b = DateTime.now().add(Duration(seconds: 1));

    expect(() => randomTimeBetween(a, a), throwsArgumentError);
    expect(() => randomTimeBetween(b, b), throwsArgumentError);
    expect(() => randomTimeBetween(b, a), throwsArgumentError);

    randomTimeBetween(a, b); // а так ок
  });
}
