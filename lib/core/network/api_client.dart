import 'package:dio/dio.dart';
import 'package:netlab/core/network/failure.dart';

class ApiClient {
  final Dio _dio;
  ApiClient(this._dio);

  // 例外経路（接続/タイムアウト等）はここでマップ
  Never _map(DioException e) {
    final s = e.response?.statusCode;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw const AppFailure(FailureType.timeout);
      case DioExceptionType.connectionError:
        throw const AppFailure(FailureType.network);
      case DioExceptionType.cancel:
        throw const AppFailure(FailureType.cancel);
      default:
        if (s == 401) {
          throw const AppFailure(FailureType.unauthorized, status: 401);
        }
        if (s != null && s >= 400 && s < 500) {
          throw AppFailure(FailureType.client, status: s);
        }
        if (s != null && s >= 500) {
          throw AppFailure(FailureType.server, status: s);
        }
        throw const AppFailure(FailureType.unknown);
    }
  }

  // レスポンス経路（非2xxはここでAppFailureへ）
  Never _mapFromStatus(int status, {Object? data}) {
    // サーバのエラーメッセージを拾う（よくある {message: "..."} に対応）
    String? msg;
    if (data is Map && data['message'] is String) {
      msg = data['message'] as String;
    }

    if (status == 401) {
      throw AppFailure(FailureType.unauthorized, status: status, message: msg);
    }
    if (status >= 400 && status < 500) {
      throw AppFailure(FailureType.client, status: status, message: msg);
    }
    if (status >= 500) {
      throw AppFailure(FailureType.server, status: status, message: msg);
    }
    throw const AppFailure(FailureType.unknown);
  }

  void _maybeThrowFromResponse(Response r) {
    final s = r.statusCode ?? 0;
    // 204 No Content はOK扱い
    final ok = (s >= 200 && s < 300);
    if (!ok) _mapFromStatus(s, data: r.data);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      final r = await _dio.get<T>(
        path,
        queryParameters: query,
        options: options,
      );
      _maybeThrowFromResponse(r);
      return r;
    } on DioException catch (e) {
      _map(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      final r = await _dio.post<T>(
        path,
        data: data,
        queryParameters: query,
        options: options,
      );
      return r;
    } on DioException catch (e) {
      _map(e);
    }
  }
}
