import 'package:dio/dio.dart';
import 'package:netlab/core/network/api_client.dart';
import 'package:netlab/features/user/data/user_data_source.dart';
import 'package:netlab/features/user/data/user_dto.dart';

class RemoteUserDataSource implements UserDataSource {
  final ApiClient _api;
  RemoteUserDataSource(this._api);

  @override
  Future<UserDto> fetchUser(int id, {CancelToken? cancelToken}) async {
    final r = await _api.get<Map<String, dynamic>>('/users/$id');
    return UserDto.fromJson(r.data!);
  }
}
