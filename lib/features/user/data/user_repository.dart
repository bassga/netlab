import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/features/user/data/fake_user_data_source.dart';
import 'package:netlab/features/user/data/user_data_source.dart';
import 'package:netlab/features/user/data/user_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

abstract class UserRepository {
  Future<UserDto> getUser(int id, {CancelToken? cancel});
}

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _ds;
  UserRepositoryImpl(this._ds);

  @override
  Future<UserDto> getUser(int id, {CancelToken? cancel}) {
    return _ds.fetchUser(id, cancelToken: cancel);
  }
}

@riverpod
UserRepository userRepository(Ref ref) {
  // まずは Fake だけで起動確認（Remoteは次PRで差し替える）
  return UserRepositoryImpl(FakeUserDataSource());
}
