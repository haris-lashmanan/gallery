import 'package:dio/dio.dart';

import '../config/env_config.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        queryParameters: {'key': EnvConfig.apiKey, 'image_type': 'photo'},
      ),
    );

    if (!EnvConfig.isProd) {
      dio.interceptors.add(
        LogInterceptor(request: false, responseBody: true, error: true),
      );
    }
  }
}
