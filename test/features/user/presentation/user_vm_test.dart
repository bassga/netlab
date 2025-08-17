import 'package:dio/src/cancel_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netlab/features/user/data/user_dto.dart';
import 'package:netlab/features/user/data/user_repository.dart';
import 'package:netlab/features/user/presentation/user_vm.dart';

class _RepoFake implements UserRepository {
  @override
  Future<UserDto> getUser(int id, {CancelToken? cancel}) async =>
      const UserDto(id: 1, name: 'test', username: 'test', email: 't@e');
}

void main() {
  test('UserVm loads', () async {
    final c = ProviderContainer(
      overrides: [userRepositoryProvider.overrideWith((_) => _RepoFake())],
    );
    addTearDown(c.dispose);

    final text = await c.read(userVmProvider.future);
    expect(text, contains('Test'));
  });
}
