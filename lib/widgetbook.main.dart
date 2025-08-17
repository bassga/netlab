import 'package:flutter/material.dart';
import 'package:netlab/stories/user_card_stories.dart';
import 'package:widgetbook/widgetbook.dart';

void main() => runApp(const _WB());

class _WB extends StatelessWidget {
  const _WB({super.key});
  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      appBuilder: (context, child) {
        final isDark = context.knobs.boolean(
          label: 'Dark mode',
          initialValue: false,
        );

        final brightness = isDark ? Brightness.dark : Brightness.light;

        final scaleInput = context.knobs.string(
          label: 'Text Scale(e.g. 1.0 / 1.3 / 1.6)',
          initialValue: '1.0',
        );

        final textScale = double.tryParse(scaleInput) ?? 1.0;

        final theme = ThemeData(
          useMaterial3: true,
          brightness: brightness,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: brightness,
          ),
        );
        return MaterialApp(
          theme: theme,
          builder: (context, child2) => MediaQuery.withClampedTextScaling(
            minScaleFactor: 1.0,
            maxScaleFactor: textScale,
            child: child2!,
          ),
          home: Scaffold(body: SafeArea(child: child)),
        );
      },
      directories: [
        WidgetbookCategory(name: 'Components', children: [userCardStories()]),
      ],
    );
  }
}
