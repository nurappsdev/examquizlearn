class ErrorResponse {
  final String? status;
  final int? statusCode;
  final String? message;

  ErrorResponse({this.status, this.statusCode, this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
    status: json["status"]?.toString(),
    statusCode: json["statusCode"] is int ? json["statusCode"] : null,
    message: json["message"]?.toString(),
  );
}
