class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  const ApiException({
    this.statusCode,
    required this.message,
    this.data,
  });

  bool get isBadRequest => statusCode == 400;

  bool get isUnauthorized => statusCode == 401;

  bool get isForbidden => statusCode == 403;

  bool get isNotFound => statusCode == 404;

  bool get isValidationError => statusCode == 422;

  bool get isServerError =>
      statusCode != null && statusCode! >= 500;

  @override
  String toString() {
    if (statusCode == null) {
      return 'ApiException: $message';
    }

    return 'ApiException($statusCode): $message';
  }
}