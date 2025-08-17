import 'package:dio/dio.dart';

/// アクセストークンを非同期に取得する関数型
typedef TokenProvider = Future<String?> Function();

/// リクエストごとに Authorization: Bearer <token> を付与する Interceptor
class AuthInterceptor extends Interceptor {
  final TokenProvider tokenProvider;
  AuthInterceptor(this.tokenProvider);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await tokenProvider();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // トークン取得失敗時は何もしない（通信は継続）
    }
    handler.next(options);
  }
}
