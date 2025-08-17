import 'package:dio/dio.dart';
import 'package:netlab/features/user/data/user_dto.dart';

abstract class UserDataSource {
  Future<UserDto> fetchUser(int id, {CancelToken? cancelToken});
}
