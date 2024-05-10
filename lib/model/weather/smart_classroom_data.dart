class SmartClassroom {
  final String? date;
  final String time;
  final String sensorReadStatus;
  final String temp;
  final String humidity;
  final int numberOfStudents;
  final String exhaustFanStatus;

  const SmartClassroom({
    this.date,
    required this.time,
    required this.sensorReadStatus,
    required this.temp,
    required this.humidity,
    required this.numberOfStudents,
    required this.exhaustFanStatus,
  });
}
