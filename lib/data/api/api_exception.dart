enum ApiFailureKind {
  configuration,
  offline,
  timeout,
  server,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  invalidRequest,
  invalidResponse,
  unknown,
}

class ApiException implements Exception {
  const ApiException(this.kind, this.message, {this.statusCode});

  final ApiFailureKind kind;
  final String message;
  final int? statusCode;

  factory ApiException.fromStatus(int status, String message) {
    final kind = switch (status) {
      400 => ApiFailureKind.invalidRequest,
      401 => ApiFailureKind.unauthorized,
      403 => ApiFailureKind.forbidden,
      404 => ApiFailureKind.notFound,
      409 => ApiFailureKind.conflict,
      >= 500 => ApiFailureKind.server,
      _ => ApiFailureKind.unknown,
    };
    return ApiException(kind, message, statusCode: status);
  }

  @override
  String toString() => 'ApiException(${statusCode ?? kind.name}): $message';
}
