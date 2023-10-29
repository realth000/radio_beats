import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radio_beats/providers/player_provider.dart';
import 'package:radio_beats/providers/radio_list_provider.dart';
import 'package:radio_beats/providers/settings_provider.dart';
import 'package:radio_beats/router/router.dart';
import 'package:radio_beats/themes/app_theme.dart';
import 'package:radio_beats/utils/platform.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSettings();
  await initRadioModelList();

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
