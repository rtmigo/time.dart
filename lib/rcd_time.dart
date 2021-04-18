import 'dart:math';

// microseconds work on VM, but not JS
final bool microsecondsSupported = 
    (DateTime(2020, 02, 20, 20, 20, 20, 20, 20))
    .isBefore(DateTime(2020, 02, 20, 20, 20, 20, 20, 21));

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


@deprecated
Duration durationFromMillis(double ms) => durationFromMilliseconds(ms);

// todo unit test in JS
Duration durationFromSeconds(double sec) =>
    Duration(microseconds: (sec * Duration.microsecondsPerSecond).round());

// todo unit test in JS
Duration durationFromMilliseconds(double ms) =>
    Duration(microseconds: (ms * Duration.microsecondsPerMillisecond).round());


/// Generates random [DateTime] uniformly distributed in the specified range.
DateTime randomTimeBetween(DateTime minInc, DateTime maxExc, {Random? random}) {
  if (maxExc.isBefore(minInc) || maxExc.isAtSameMomentAs(minInc)) {
    throw ArgumentError();
  }

  int ia = microsecondsSupported ? minInc.microsecondsSinceEpoch : minInc.millisecondsSinceEpoch;
  int ib = microsecondsSupported ? maxExc.microsecondsSinceEpoch : maxExc.millisecondsSinceEpoch;

  random??=Random();

  int ic = ia + random.nextInt(ib - ia);

  final result = microsecondsSupported ? DateTime.fromMicrosecondsSinceEpoch(ic) : DateTime.fromMillisecondsSinceEpoch(ic);

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

  DateTime roundToSecond() {
    var result = this.floorToSecond();

    final mcs = this.millisecond * Duration.microsecondsPerMillisecond + this.microsecond;

    if (mcs >= (Duration.microsecondsPerSecond >> 1)) {
      result = result.add(const Duration(seconds: 1));
    }
    return result;
  }

  @deprecated // since 2021-04
  DateTime roundToSeconds() => roundToSeconds();

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
