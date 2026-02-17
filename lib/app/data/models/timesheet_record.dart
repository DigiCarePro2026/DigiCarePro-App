class TimesheetRecord {
  String id;
  String date;
  String? startTime;
  String? endTime;
  int totalMinutes;
  int missionWorkMinutes;
  int pauseMinutes;
  String totalTimeDisplay;
  String workTimeDisplay;
  String pauseTimeDisplay;
  bool vacation;

  TimesheetRecord({
    required this.id,
    required this.date,
    this.startTime,
    this.endTime,
    required this.totalMinutes,
    required this.missionWorkMinutes,
    required this.pauseMinutes,
    required this.totalTimeDisplay,
    required this.workTimeDisplay,
    required this.pauseTimeDisplay,
    required this.vacation,
  });

  factory TimesheetRecord.fromJson(Map<String, dynamic> json) => TimesheetRecord(
    id: json['id'],
    date: json['date'],
    startTime: json['startTime'],
    endTime: json['endTime'],
    totalMinutes: json['totalMinutes'] ?? 0,
    missionWorkMinutes: json['missionWorkMinutes'] ?? 0,
    pauseMinutes: json['pauseMinutes'] ?? 0,
    totalTimeDisplay: json['totalTimeDisplay'] ?? '0',
    workTimeDisplay: json['workTimeDisplay'] ?? '0',
    pauseTimeDisplay: json['pauseTimeDisplay'] ?? '0',
    vacation: json['vacation'],
  );
}
