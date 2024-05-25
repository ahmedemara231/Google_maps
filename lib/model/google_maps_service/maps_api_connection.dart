import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:multiple_result/multiple_result.dart';
import 'api_request.dart';
import 'error_handling/errors.dart';
import 'error_handling/handle_errors.dart';
import 'google_maps_api_constants.dart';
import 'request_model.dart';

class GoogleMapsConnection implements ApiService
{
  late Dio dio;

  GoogleMapsConnection()
  {
    dio = Dio()
      ..options.connectTimeout = MapsConstants.timeoutDuration
      ..options.receiveTimeout = MapsConstants.timeoutDuration;
  }

  static GoogleMapsConnection? googleMapsConnection;

  static GoogleMapsConnection getInstance()
  {
    return googleMapsConnection ??= GoogleMapsConnection();
  }


  @override
  Future<Result<Response,CustomError>> callApi({
    required RequestModel request,
  }) async
  {
    final connectivityResult = await Connectivity().checkConnectivity();

    switch(connectivityResult)
    {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
        try{
          final Response response = await dio.request(
            request.endPoint,
            options: Options(
              headers: request.headers,
              receiveDataWhenStatusError: true,
              responseType: request.responseType?? ResponseType.json,
              method: request.method,
            ),
            data: request.data,
            queryParameters: request.queryParams,
            onSendProgress: request.onSendProgress,
            onReceiveProgress: request.onReceiveProgress,
          );

          // String prettyJson = const JsonEncoder.withIndent('  ').convert(response.data);
          // log(prettyJson);

          return Result.success(response);
        }on DioException catch(e)
        {
          String prettyJson = const JsonEncoder.withIndent('  ').convert(e.response?.data);
          log(prettyJson);
          return Result.error(handleErrors(e));
        }
      case ConnectivityResult.none:
      default:
        return Result.error(
          NetworkError(
              'Please check the internet and try again'
          ),
        );
    }
  }
}
