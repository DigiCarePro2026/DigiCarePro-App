enum MissionType{
  all,
  todo,
  inProgress,
  done;
}

extension MissionTypeExtension on MissionType {
  String get title {
    switch (this) {
      case MissionType.all:
        return 'All';
      case MissionType.todo:
        return 'Todo';
      case MissionType.inProgress:
        return 'In progress';
      case MissionType.done:
        return 'Done';
    }
  }
}