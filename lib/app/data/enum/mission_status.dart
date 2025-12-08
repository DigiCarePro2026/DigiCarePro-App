enum MissionStatus{
  draft(1),
  inProgress(2),
  completed(3);

  final int code;

  const MissionStatus(this.code);
}