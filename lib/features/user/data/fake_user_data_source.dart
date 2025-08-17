import 'package:dio/dio.dart';
import 'package:netlab/features/user/data/user_data_source.dart';
import 'package:netlab/features/user/data/user_dto.dart';

class FakeUserDataSource implements UserDataSource {
  @override
  Future<UserDto> fetchUser(int id, {CancelToken? cancelToken}) async {
    await Future.delayed(const Duration(milliseconds: 5));
    return UserDto(
      id: id,
      name: 'dev user',
      username: 'dev_$id',
      email: 'g$id@example.com',
    );
  }
}
