import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../storage/secure_storage_service.dart';

class AuthInterceptor extends QueuedInterceptor {
  final SecureStorageService _storageService;
  final Dio _dio;

  AuthInterceptor({
    required SecureStorageService storageService,
    required Dio dio,
  })  : _storageService = storageService,
        _dio = dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers[AppConstants.headerAuthorization] =
          '${AppConstants.headerBearerPrefix}$token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Attempt token refresh with ASP.NET Core backend
          final refreshResponse = await _dio.post(
            '/auth/refresh-token',
            data: {'refreshToken': refreshToken},
            options: Options(
              headers: {AppConstants.headerAuthorization: null},
            ),
          );

          if (refreshResponse.statusCode == 200 &&
              refreshResponse.data != null) {
            final newAccessToken =
                refreshResponse.data['data']?['accessToken'] ??
                    refreshResponse.data['accessToken'];
            final newRefreshToken =
                refreshResponse.data['data']?['refreshToken'] ??
                    refreshResponse.data['refreshToken'];

            if (newAccessToken != null) {
              await _storageService.saveAccessToken(newAccessToken.toString());
              if (newRefreshToken != null) {
                await _storageService
                    .saveRefreshToken(newRefreshToken.toString());
              }

              // Retry original failed request with updated access token
              final retryOptions = err.requestOptions;
              retryOptions.headers[AppConstants.headerAuthorization] =
                  '${AppConstants.headerBearerPrefix}$newAccessToken';

              final retryResponse = await _dio.fetch(retryOptions);
              return handler.resolve(retryResponse);
            }
          }
        } catch (_) {
          // Refresh failed - purge stored credentials
          await _storageService.clearAuthTokens();
        }
      } else {
        await _storageService.clearAuthTokens();
      }
    }
    return handler.next(err);
  }
}

