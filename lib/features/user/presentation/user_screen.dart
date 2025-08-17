import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/features/user/presentation/user_vm.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(userVmProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('User Sample')),
      body: Center(
        child: s.when(
          data: (t) => Text(t, textAlign: TextAlign.center),
          error: (e, _) => Text('$e', textAlign: TextAlign.center),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(userVmProvider.notifier).refresh(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
