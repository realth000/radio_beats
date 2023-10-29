import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radio_beats/models/radio_model.dart';
import 'package:radio_beats/providers/player_provider.dart';
import 'package:radio_beats/providers/radio_list_provider.dart';
import 'package:radio_beats/providers/settings_provider.dart';

class RadioView extends ConsumerStatefulWidget {
  /// Constructor.
  const RadioView({super.key});

  @override
  ConsumerState<RadioView> createState() => _RadioViewState();
}

class _RadioViewState extends ConsumerState<RadioView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _radioListScrollController.dispose();
    super.dispose();
  }

  final _radioListScrollController = ScrollController();

  Widget buildSmallSpace() => const SizedBox(
        width: 10,
        height: 10,
      );

  Future<Widget> _buildRadioList(BuildContext context, WidgetRef ref) async {
    final defaultRadioLists = ref.read(radioListProvider);
    return ListView.builder(
      controller: _radioListScrollController,
      itemCount: defaultRadioLists.length,
      itemExtent: 60,
      itemBuilder: (context, index) =>
          defaultRadioLists[index].buildRadioListTile(ref),
    );
  }

  Widget _buildControlCard() {
    final player = ref.watch(playerProvider);
    final settings = ref.watch(settingsProvider);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final r = player.currentRadio;
                if (r == null) {
                  return;
                }
                await ref.read(playerProvider.notifier).play(r);
              },
              child: const Icon(Icons.play_arrow),
            ),
            buildSmallSpace(),
            ElevatedButton(
              onPressed: () async => ref.read(playerProvider.notifier).stop(),
              child: const Icon(Icons.stop),
            ),
            buildSmallSpace(),
            IconButton(
              icon: _buildVolumeButton(ref),
              onPressed: () async {
                if (settings.volume == 0) {
                  await ref
                      .watch(settingsProvider.notifier)
                      .setVolume(settings.lastNotZeroVolume);
                  await ref
                      .watch(playerProvider.notifier)
                      .setVolume(settings.lastNotZeroVolume);
                } else {
                  // Save volume.
                  await ref
                      .watch(settingsProvider.notifier)
                      .setLastNotZeroVolume(settings.volume);
                  // Mute.
                  await ref.watch(settingsProvider.notifier).setVolume(0);
                  await ref.watch(playerProvider.notifier).setVolume(0);
                }
              },
            ),
            buildSmallSpace(),
            Consumer(
              builder: (context, ref, _) => Slider(
                // value: ref.read(settingsProvider).volume,
                value: settings.volume,
                onChanged: (value) async {
                  await ref.read(playerProvider.notifier).setVolume(value);
                  await ref.read(settingsProvider.notifier).setVolume(value);
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildVolumeButton(WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    if (settings.volume == 0) {
      return const Icon(Icons.volume_mute);
    }
    if (settings.volume < 0.3) {
      return const Icon(Icons.volume_down);
    }
    return const Icon(Icons.volume_up);
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: FutureBuilder(
              future: _buildRadioList(context, ref),
              builder: (context, snapshot) {
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data == null) {
                  return ListView();
                } else {
                  return snapshot.data!;
                }
              },
            ),
          ),
          _buildControlCard(),
        ],
      );
}
