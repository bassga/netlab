import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/core/network/auth_interceptor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

/// とりあえずのダミー実装（次PRでSecureStorage等に差し替え）
/// null を返せば Authorization は付与されない
@riverpod
Future<String?> authToken(Ref ref) async {
  // TODO: 次PRで永続化/更新と接続
  return null;
}

@riverpod
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: ''),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: const {
        'Accept': 'application/json',
        'User-Agent': 'netlab/0.1 (+flutter; dio)',
      },
      // 4xx/5xxでも例外にせず Response を返す → ApiClient側で分類
      validateStatus: (s) => s != null && s >= 200 && s < 600,
    ),
  );

  // ---- Interceptors ----
  dio.interceptors.add(
    AuthInterceptor(() => ref.read(authTokenProvider.future)),
  );
  return dio;
}
