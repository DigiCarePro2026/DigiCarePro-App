class ApiError {
  int code;
  String message;
  bool isTimeout;

  ApiError({required this.code, required this.message, this.isTimeout = false});
}
