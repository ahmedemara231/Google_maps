import 'package:dio/dio.dart';

class RequestModel
{
  String method;
  String endPoint;
  Map<String,dynamic>? headers;
  dynamic data;

  Map<String,dynamic>? queryParams;
  ResponseType? responseType;
  void Function(int count, int total)? onSendProgress;
  void Function(int count, int total)? onReceiveProgress;

  RequestModel({
    required this.method,
    required this.endPoint,
    this.headers,
    this.data,
    this.queryParams,
    this.responseType,
    this.onSendProgress,
    this.onReceiveProgress,
});
}