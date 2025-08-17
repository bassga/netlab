import 'package:dio/dio.dart';
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

class _RepoError implements UserRepository {
  @override
  Future<UserDto> getUser(int id, {CancelToken? cancel}) async {
    throw Exception('boom');
  }
}

class _RepoCounting implements UserRepository {
  int n = 0;
  @override
  Future<UserDto> getUser(int id, {cancel}) async {
    n++;
    return UserDto(id: 1, name: 'N$n', username: 'u', email: 'e');
  }
}

void main() {
  test('UserVm loads', () async {
    final c = ProviderContainer(
      overrides: [userRepositoryProvider.overrideWith((_) => _RepoFake())],
    );
    addTearDown(c.dispose);

    final text = await c.read(userVmProvider.future);
    expect(text, contains('test')); // name (lowercase as provided by _RepoFake)
    expect(text, contains('t@e')); // email
  });

  test('UserVm error -> AsyncError', () async {
    final c = ProviderContainer(
      overrides: [userRepositoryProvider.overrideWith((_) => _RepoError())],
    );
    addTearDown(c.dispose);

    await expectLater(c.read(userVmProvider.future), throwsA(isA<Exception>()));
    expect(c.read(userVmProvider).hasError, true);
  });

  test('refresh updates text', () async {
    final c = ProviderContainer(
      overrides: [userRepositoryProvider.overrideWith((_) => _RepoCounting())],
    );
    addTearDown(c.dispose);

    final first = await c.read(userVmProvider.future);
    await c.read(userVmProvider.notifier).refresh();
    final second = await c.read(userVmProvider.future);

    expect(first, isNot(equals(second)));
  });
}
