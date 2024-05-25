import 'dart:developer';

class CustomError implements Exception
{
  String? message;

  CustomError(this.message)
  {
    log(message??'error');
  }
}

class NetworkError extends CustomError {
  NetworkError(super.message);
}

class BadResponseError extends CustomError {
  BadResponseError(super.message);
}

class BadRequestError extends CustomError {
  BadRequestError(super.message);
}