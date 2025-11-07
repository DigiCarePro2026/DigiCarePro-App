enum MissionStatus{
  notPlanned(0),
  manualStart(1),
  autoStart(2),
  getSignature(3),
  done(4);

  final int code;

  const MissionStatus(this.code);
}