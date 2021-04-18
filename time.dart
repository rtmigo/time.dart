import 'dart:math';

DateTime? maxDateTime(Iterable<DateTime?> values)
{
  DateTime? result;

  for (var t in values)
    if (result==null || (t!=null && t.isAfter(result)))
      result = t;

  return result;
}

DateTime nSecondsLater(double seconds)
{
  final dura = Duration(microseconds: (seconds*Duration.microsecondsPerSecond).round());
  return DateTime.now().toUtc().add(dura);
}

Future<void> pause(num seconds) async
{
  await Future.delayed(Duration(microseconds: (seconds*Duration.microsecondsPerSecond).round()));
}

Future<void> pauseMs(num milliseconds) async
{
  await Future.delayed(Duration(microseconds: (milliseconds*Duration.microsecondsPerMillisecond).round()));
}

Duration durationFromSeconds(double sec) => Duration(microseconds: (sec*Duration.microsecondsPerSecond).round());
Duration durationFromMillis(double ms) => Duration(microseconds: (ms*Duration.microsecondsPerMillisecond).round());

DateTime randomTimeBetween(DateTime a, DateTime b)
{
  if (b.isBefore(a) || a.isAtSameMomentAs(b))
    throw ArgumentError();
//  if (a.isAtSameMomentAs(b))
  //  return a;

  int ia = a.microsecondsSinceEpoch;
  int ib = b.microsecondsSinceEpoch;

  int ic = ia+Random().nextInt(ib-ia);

  final result = DateTime.fromMicrosecondsSinceEpoch(ic);

  assert(result.isAfter(a) || result.isAtSameMomentAs(a));
  assert(result.isBefore(b));

  return result;

}


extension DateTimeExt on DateTime {

  DateTime floorToSecond() {
    return DateTime(
        this.year,
        this.month,
        this.day,
        this.hour,
        this.minute,
        this.second);
  }

  DateTime floorToMinute() {
    return DateTime(
        this.year,
        this.month,
        this.day,
        this.hour,
        this.minute);
  }


  DateTime roundToSeconds() {

    var result = this.floorToSecond();

    final mcs = this.millisecond*Duration.microsecondsPerMillisecond + this.microsecond;

    if (mcs>=(Duration.microsecondsPerSecond>>1))
      result = result.add(const Duration(seconds: 1));
    return result;
  }

  DateTime floorToDay()
  {
    return DateTime(
        this.year,
        this.month,
        this.day);
  }

  DateTime floorToHour()
  {
    return DateTime(
        this.year,
        this.month,
        this.day,
        this.hour
    );
  }


  Duration durationSinceDayStart() {
    return this.difference(this.floorToDay());
  }
}


