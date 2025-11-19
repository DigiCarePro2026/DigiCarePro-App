class TimesheetRecord {
  String id;
  String date;
  String startTime;
  String endTime;
  int totalMinutes;
  int missionWorkMinutes;
  int pauseMinutes;
  String totalTimeDisplay;
  String workTimeDisplay;
  String pauseTimeDisplay;

  TimesheetRecord({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalMinutes,
    required this.missionWorkMinutes,
    required this.pauseMinutes,
    required this.totalTimeDisplay,
    required this.workTimeDisplay,
    required this.pauseTimeDisplay,
  });

  factory TimesheetRecord.fromJson(Map<String, dynamic> json) => TimesheetRecord(
    id: json['id'],
    date: json['date'],
    startTime: json['startTime'],
    endTime: json['endTime'],
    totalMinutes: json['totalMinutes'],
    missionWorkMinutes: json['missionWorkMinutes'],
    pauseMinutes: json['pauseMinutes'],
    totalTimeDisplay: json['totalTimeDisplay'],
    workTimeDisplay: json['workTimeDisplay'],
    pauseTimeDisplay: json['pauseTimeDisplay'],
  );
}
