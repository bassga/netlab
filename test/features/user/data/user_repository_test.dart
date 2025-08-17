import 'package:dio/src/cancel_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netlab/features/user/data/user_data_source.dart';
import 'package:netlab/features/user/data/user_dto.dart';
import 'package:netlab/features/user/data/user_repository.dart';

class _DsFake implements UserDataSource {
  @override
  Future<UserDto> fetchUser(int id, {CancelToken? cancelToken}) async =>
      const UserDto(id: 1, name: 'T', username: 't', email: 't@e');
}

void main() {
  test('Repository uses DataSource and returns DTO', () async {
    final c = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWith(
          (_) => UserRepositoryImpl(_DsFake()),
        ),
      ],
    );
    addTearDown(c.dispose);

    final repo = c.read(userRepositoryProvider);
    final u = await repo.getUser(1);
    expect(u.username, 't');
  });
}
