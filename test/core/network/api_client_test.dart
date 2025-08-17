import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:netlab/core/network/api_client.dart';
import 'package:netlab/core/network/failure.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late ApiClient api;

  setUp(() {
    dio = Dio(
      BaseOptions(baseUrl: 'https://example.com', validateStatus: (s) => true),
    );
    adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;
    api = ApiClient(dio);
  });

  test('200 OK', () async {
    adapter.onGet('/ok', (s) => s.reply(200, {'a': 1}));
    final r = await api.get<Map<String, dynamic>>('/ok');
    expect(r.data, {'a': 1});
  });

  test('401 -> unauthorized failure', () async {
    adapter.onGet('/ng', (s) => s.reply(401, {}));
    expect(
      () => api.get('/ng'),
      throwsA(
        isA<AppFailure>().having(
          (e) => e.type,
          'type',
          FailureType.unauthorized,
        ),
      ),
    );
  });

  test('500 -> server failure', () async {
    adapter.onGet('/ng', (s) => s.reply(500, {}));
    expect(
      () => api.get('/ng'),
      throwsA(
        isA<AppFailure>().having((e) => e.type, 'type', FailureType.server),
      ),
    );
  });
}
