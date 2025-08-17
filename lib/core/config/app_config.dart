import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config.g.dart';

@riverpod
bool useFake(Ref ref) =>
    const bool.fromEnvironment('USE_FAKE', defaultValue: true);
