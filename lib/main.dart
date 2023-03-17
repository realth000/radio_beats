import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'provider/player_provider.dart';
import 'provider/radio_list_provider.dart';
import 'provider/settings_provider.dart';
import 'router/router.dart';
import 'themes/app_theme.dart';
import 'utils/platform.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSettings();
  await initRadioModelList();
  if (isDesktop) {
    await _initWindow();
  }

  if (isAndroid) {
    await initAudioBackgroundService();
  }

  await initPlayWhenStart();

  // Set default [RadioModel] and play (if set).
  runApp(const RadioBeatsApp());
}

/// RadioBeats main app.
class RadioBeatsApp extends ConsumerWidget {
  /// Constructor.
  const RadioBeatsApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) => ProviderScope(
        child: MaterialApp.router(
          title: 'RadioBeats',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          routerConfig: rbRouter,
        ),
      );
}

/// Setup main window settings including size and position.
///
/// If window is set to be in center, ignore position,
Future<void> _initWindow() async {
  await windowManager.ensureInitialized();
  final settings = ProviderContainer();
  final center = settings.read(settingsProvider).windowInCenter;
  // Only apply window position when not set in center.
  if (!center) {
    await windowManager.setPosition(
      Offset(
        settings.read(settingsProvider).windowPositionDx,
        settings.read(settingsProvider).windowPositionDy,
      ),
    );
  }
  await windowManager.waitUntilReadyToShow(
      WindowOptions(
        size: Size(
          settings.read(settingsProvider).windowWidth,
          settings.read(settingsProvider).windowHeight,
        ),
        center: center,
      ), () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
