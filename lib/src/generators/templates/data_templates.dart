class DataTemplates {
  static String networkService(String projectName) => '''
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';

class NetworkService {
  late final Dio _dio;

  NetworkService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
          error: true,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) {
          handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
''';

  static String baseProvider(String projectName) => '''
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../services/network_service.dart';

abstract class BaseProvider {
  final Dio _dio = Get.find<NetworkService>().dio;

  Dio get dio => _dio;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
    return response.data as T;
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return response.data as T;
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    final response = await _dio.put<T>(path, data: data, options: options);
    return response.data as T;
  }

  Future<void> delete(String path, {Options? options}) async {
    await _dio.delete(path, options: options);
  }
}
''';

  static String baseRepository(String projectName) => '''
abstract class BaseRepository {}
''';
}
