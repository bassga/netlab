import 'package:flutter/widgets.dart';
import 'package:netlab/features/user/presentation/widgets/user_card.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent userCardStories() {
  return WidgetbookComponent(
    name: 'UserCard',
    useCases: [
      WidgetbookUseCase(
        name: 'knobs',
        builder: (context) {
          final name = context.knobs.string(
            label: 'displayName',
            initialValue: 'Garfield Dev',
          );
          final handle = context.knobs.string(
            label: 'handle',
            initialValue: '@garfield_1',
          );
          final email = context.knobs.string(
            label: 'email',
            initialValue: 'g1@example.com',
          );
          return Padding(
            padding: const EdgeInsets.all(16),
            child: UserCard(displayName: name, handle: handle, email: email),
          );
        },
      ),
      WidgetbookUseCase(
        name: 'default',
        builder: (context) => const Padding(
          padding: EdgeInsets.all(16),
          child: UserCard(
            displayName: 'Garfield Dev',
            handle: '@garfield_1',
            email: 'g1@example.com',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'long-text',
        builder: (context) => const Padding(
          padding: EdgeInsets.all(16),
          child: UserCard(
            displayName: 'Very Very Long Name For Robust Layout',
            handle: '@very_long_handle_for_testing_overflow',
            email:
                'very-long-email-address-for-layout@example-very-long-domain.dev',
          ),
        ),
      ),
    ],
  );
}
