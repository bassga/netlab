import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:netlab/core/network/auth_interceptor.dart';
import 'package:netlab/core/network/dio_provider.dart';

void main() {
  test('authTokenProvider を override すると Authorization が付与される', () async {
    final container = ProviderContainer(
      overrides: [
        authTokenProvider.overrideWith((ref) async => 'xyz789'),
        dioProvider.overrideWith((ref) {
          final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
          final adapter = DioAdapter(dio: dio);
          dio.httpClientAdapter = adapter;

          dio.interceptors.add(
            AuthInterceptor(() => ref.read(authTokenProvider.future)),
          );
          return dio;
        }),
      ],
    );
    addTearDown(container.dispose);

    final dio = container.read(dioProvider);

    final adapter = dio.httpClientAdapter as DioAdapter;
    adapter.onGet(
      '/secure',
      (server) => server.reply(200, {'ok': true}),
      headers: {'authorization': 'Bearer xyz789'},
    );

    final res = await dio.get('/secure');
    expect(res.statusCode, 200);
    expect(res.data, {'ok': true});
  });
}
