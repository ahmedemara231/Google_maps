import 'package:Google_maps/model/google_maps_service/request_model.dart';
import 'package:dio/dio.dart';
import 'package:multiple_result/multiple_result.dart';
import 'error_handling/errors.dart';

abstract class ApiService
{
  Future<Result<Response,CustomError>> callApi({
    required RequestModel request,
  });
}