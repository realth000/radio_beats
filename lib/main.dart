import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'router/router.dart';
import 'services/player_service.dart';
import 'themes/app_theme.dart';
import 'utils/platform.dart';

void main() async {
  if (isAndroid) {
    await initAudioBackgroundService();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ProviderScope(
        child: MaterialApp.router(
          title: 'Flutter Demo',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          routerConfig: RBRouter,
        ),
      );
}
