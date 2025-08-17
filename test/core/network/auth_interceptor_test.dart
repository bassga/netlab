import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:netlab/core/network/auth_interceptor.dart';

void main() {
  test('トークンあり -> Authorizationが付与される', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;

    dio.interceptors.add(AuthInterceptor(() async => 'abc123'));

    adapter.onGet(
      '/users/1',
      (server) => server.reply(200, {'ok': true}),
      headers: {'authorization': 'Bearer abc123'},
    );

    final res = await dio.get('/users/1');
    expect(res.statusCode, 200);
    expect(res.data, {'ok': true});
  });

  test('ヘッダーが無い場合 -> モックにマッチせずエラーになる', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;

    adapter.onGet(
      '/users/1',
      (server) => server.reply(200, {'ok': true}),
      headers: {'authorization': 'Bearer abc123'},
    );

    final resFuture = dio.get('/users/1');

    expect(resFuture, throwsA(isA<DioException>()));
  });

  test('トークンなし -> Authorizationは付与されない', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;

    dio.interceptors.add(AuthInterceptor(() async => null));

    adapter.onGet('/ping', (server) => server.reply(200, {'pong': true}));

    final res = await dio.get('/ping');
    expect(res.statusCode, 200);
    expect(res.data, {'pong': true});
  });
}
