class SignatureMissionRequest {
  final String missionId;
  final bool completeWithoutSignature;
  final List<int>? imageData;

  SignatureMissionRequest({required this.missionId, required this.completeWithoutSignature, this.imageData});
}
