import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Dio HTTP client with interceptors for OpenAI API
class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.openai.com/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      _authInterceptor(),
      _logInterceptor(),
      _errorInterceptor(),
    ]);
  }

  /// Auth Interceptor — automatically attaches OpenAI API Key
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
        if (apiKey.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $apiKey';
        }
        handler.next(options);
      },
    );
  }

  /// Log Interceptor — prints request/response for debugging
  Interceptor _logInterceptor() {
    return LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: false,
      responseHeader: false,
      logPrint: (obj) => print('🌐 DIO: $obj'),
    );
  }

  /// Error Interceptor — handles common HTTP errors
  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        String message;
        switch (error.response?.statusCode) {
          case 401:
            message = 'Invalid API Key. Please check your .env file.';
            break;
          case 429:
            message = 'Rate limit exceeded. Please wait and try again.';
            break;
          case 500:
            message = 'Server error. Please try again later.';
            break;
          case 503:
            message = 'Service unavailable. Please try again later.';
            break;
          default:
            if (error.type == DioExceptionType.connectionTimeout ||
                error.type == DioExceptionType.receiveTimeout) {
              message = 'Connection timeout. Please check your internet.';
            } else if (error.type == DioExceptionType.connectionError) {
              message = 'No internet connection. Working in offline mode.';
            } else {
              message = error.message ?? 'An unexpected error occurred.';
            }
        }
        handler.next(
          DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: message,
            message: message,
          ),
        );
      },
    );
  }
}
