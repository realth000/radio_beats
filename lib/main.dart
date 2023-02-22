import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'provider/player_provider.dart';
import 'router/router.dart';
import 'themes/app_theme.dart';
import 'utils/platform.dart';

void main() async {
  await Hive.initFlutter();
  final settinsBox = await Hive.openBox('settings');
  // if (settinsBox.isEmpty) {
  //   await settinsBox.putAll(Settings().toMap);
  // } else {}

  if (isAndroid) {
    await initAudioBackgroundService();
  }
  runApp(const MyApp());
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) => ProviderScope(
        child: MaterialApp.router(
          title: 'Flutter Demo',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          routerConfig: RBRouter,
        ),
      );
}
