import 'dart:math';

DateTime? maxDateTime(Iterable<DateTime?> values) {
  DateTime? result;

  for (var t in values) {
    if (result == null || (t != null && t.isAfter(result))) {
      result = t;
    }
  }

  return result;
}

DateTime nSecondsLater(double seconds) {
  final dura = Duration(microseconds: (seconds * Duration.microsecondsPerSecond).round());
  return DateTime.now().toUtc().add(dura);
}

Future<void> pause(num seconds) async {
  await Future.delayed(Duration(microseconds: (seconds * Duration.microsecondsPerSecond).round()));
}

Future<void> pauseMs(num milliseconds) async {
  await Future.delayed(
      Duration(microseconds: (milliseconds * Duration.microsecondsPerMillisecond).round()));
}

Duration durationFromSeconds(double sec) =>
    Duration(microseconds: (sec * Duration.microsecondsPerSecond).round());

Duration durationFromMillis(double ms) =>
    Duration(microseconds: (ms * Duration.microsecondsPerMillisecond).round());

/// Generates random [DateTime] within the specified interval.
DateTime randomTimeBetween(DateTime minInc, DateTime maxExc, {Random? random}) {
  if (maxExc.isBefore(minInc) || maxExc.isAtSameMomentAs(minInc)) {
    throw ArgumentError();
  }

  int ia = minInc.microsecondsSinceEpoch;
  int ib = maxExc.microsecondsSinceEpoch;

  random??=Random();

  int ic = ia + random.nextInt(ib - ia);

  final result = DateTime.fromMicrosecondsSinceEpoch(ic);

  assert(result.isAfter(minInc) || result.isAtSameMomentAs(minInc));
  assert(result.isBefore(maxExc));

  return result;
}

extension DateTimeExt on DateTime {

  DateTime floorToSecond() {
    return DateTime(this.year, this.month, this.day, this.hour, this.minute, this.second);
  }

  DateTime floorToMinute() {
    return DateTime(this.year, this.month, this.day, this.hour, this.minute);
  }

  DateTime roundToSeconds() {
    var result = this.floorToSecond();

    final mcs = this.millisecond * Duration.microsecondsPerMillisecond + this.microsecond;

    if (mcs >= (Duration.microsecondsPerSecond >> 1)) {
      result = result.add(const Duration(seconds: 1));
    }
    return result;
  }

  DateTime floorToDay() {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime floorToHour() {
    return DateTime(this.year, this.month, this.day, this.hour);
  }

  Duration durationSinceDayStart() {
    return this.difference(this.floorToDay());
  }
}
