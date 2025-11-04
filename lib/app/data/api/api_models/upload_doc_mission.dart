class UploadDocMissionRequest {
  final String missionId;
  final String customerId;
  final String? title;
  final List<int> imageData;

  UploadDocMissionRequest({required this.missionId, required this.customerId, this.title, required this.imageData});
}
