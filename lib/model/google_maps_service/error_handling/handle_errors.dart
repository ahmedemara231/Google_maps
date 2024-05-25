import 'dart:developer';
import 'package:dio/dio.dart';
import 'errors.dart';

CustomError handleErrors(DioException e)
{
  log('code : ${e.response?.statusCode}');

  switch(e.response!.statusCode)
  {
    case 400:
      return BadRequestError(
          '${e.response?.data['error']['message']}'
      );

    case 403:
      return BadRequestError(
          '${e.response?.data['error']['message']}'
      );

    default:
      return CustomError(
          '${e.response?.data['error']['message']}'
      );
  }
}