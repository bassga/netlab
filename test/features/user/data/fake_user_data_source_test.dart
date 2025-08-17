import 'package:flutter_test/flutter_test.dart';
import 'package:netlab/features/user/data/fake_user_data_source.dart';

void main() {
  test('Fake returns DTO', () async {
    final u = await FakeUserDataSource().fetchUser(7);
    expect(u.username, 'dev_7');
  });
}
