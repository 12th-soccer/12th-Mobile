import 'dart:convert';

import 'package:dio/dio.dart';

enum ApiErrorType {
  badResponse,
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  cancel,
  connectionError,
  unknown,
}

class ApiException implements Exception {
  final int? statusCode;
  final String? message;
  final Object? responseData;
  final Uri? uri;
  final ApiErrorType type;
  final Object? cause;

  const ApiException({
    required this.type,
    this.statusCode,
    this.message,
    this.responseData,
    this.uri,
    this.cause,
  });

  bool get isTimeout =>
      type == ApiErrorType.connectionTimeout ||
      type == ApiErrorType.sendTimeout ||
      type == ApiErrorType.receiveTimeout;

  @override
  String toString() {
    return 'ApiException('
        'type: $type, '
        'statusCode: $statusCode, '
        'message: $message, '
        'uri: $uri'
        ')';
  }
}

abstract interface class ApiClient {
  Future<T> get<T>(
    String path, {
    Map<String, Object?>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic data) decoder,
  });

  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic data) decoder,
  });

  Future<T> patch<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic data) decoder,
  });

  Future<void> postVoid(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<void> deleteVoid(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, dynamic>? headers,
  });
}

class DioApiClient implements ApiClient {
  final Dio _dio;

  DioApiClient(this._dio);

  @override
  Future<T> get<T>(
    String path, {
    Map<String, Object?>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic data) decoder,
  }) {
    return _request(
      'GET',
      path,
      queryParameters: queryParameters,
      headers: headers,
      decoder: decoder,
    );
  }

  @override
  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic data) decoder,
  }) {
    return _request(
      'POST',
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      decoder: decoder,
    );
  }

  @override
  Future<T> patch<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic data) decoder,
  }) {
    return _request(
      'PATCH',
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      decoder: decoder,
    );
  }

  @override
  Future<void> postVoid(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _requestVoid(
      'POST',
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  @override
  Future<void> deleteVoid(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _requestVoid(
      'DELETE',
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  Future<T> _request<T>(
    String method,
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic data) decoder,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method, headers: headers),
      );
      return decoder(_normalizeData(response.data));
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  Future<void> _requestVoid(
    String method,
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      await _dio.request<void>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method, headers: headers),
      );
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  ApiException _toApiException(DioException e) {
    return ApiException(
      type: _mapErrorType(e.type),
      statusCode: e.response?.statusCode,
      message: e.message,
      responseData: _normalizeData(e.response?.data),
      uri: e.requestOptions.uri,
      cause: e.error ?? e,
    );
  }

  ApiErrorType _mapErrorType(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.badResponse:
        return ApiErrorType.badResponse;
      case DioExceptionType.connectionTimeout:
        return ApiErrorType.connectionTimeout;
      case DioExceptionType.sendTimeout:
        return ApiErrorType.sendTimeout;
      case DioExceptionType.receiveTimeout:
        return ApiErrorType.receiveTimeout;
      case DioExceptionType.cancel:
        return ApiErrorType.cancel;
      case DioExceptionType.connectionError:
        return ApiErrorType.connectionError;
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return ApiErrorType.unknown;
    }
  }

  dynamic _normalizeData(dynamic rawData) {
    if (rawData is String && rawData.isNotEmpty) {
      try {
        return jsonDecode(rawData);
      } on FormatException {
        return rawData;
      }
    }
    return rawData;
  }
}
