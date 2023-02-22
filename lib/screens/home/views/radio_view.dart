import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/radio_model.dart';
import '../../../provider/player_provider.dart';
import '../../../provider/settings_provider.dart';

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

  final _radioListScrollController = ScrollController(
    keepScrollOffset: true,
  );

  Widget buildSmallSpace() => const SizedBox(
        width: 10,
        height: 10,
      );

  List<RadioModel> _buildDefaultRadioList(String str) {
    final modelList = <RadioModel>[];
    str.split('\n').forEach((s) {
      final ss = s.split('|');
      if (ss.length != 6) {
        return;
      }
      modelList.add(
        RadioModel(
          ss[1],
          ss[0],
          style: ss[2],
          language: ss[3],
          sampleRate: int.parse(ss[4]),
        ),
      );
    });
    return modelList;
  }

  ListTile _buildAudioListTile(RadioModel radioModel, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    return ListTile(
      horizontalTitleGap: 10,
      leading: Text(
        radioModel.language ?? '',
        maxLines: 1,
        style: const TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w600,
        ),
      ),
      title: Text(
        radioModel.name,
        maxLines: 1,
      ),
      subtitle: Text(
        radioModel.url,
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) => <PopupMenuItem<int>>[
          PopupMenuItem(
            value: 0,
            child: Row(
              children: const [
                Icon(Icons.play_arrow),
                Text('Play'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 1,
            child: Row(
              children: const [
                Icon(Icons.copy),
                Text('Copy url'),
              ],
            ),
          ),
        ],
        onSelected: (value) async {
          switch (value) {
            case 0:
              player.currentRadio = radioModel;
              await ref.read(playerProvider.notifier).play(radioModel);
              return;
            case 1:
              await Clipboard.setData(ClipboardData(text: radioModel.url));
              return;
          }
        },
      ),
    );
  }

  Future<Widget> _buildRadioList(BuildContext context, WidgetRef ref) async {
    final defaultRadioLists = _buildDefaultRadioList(
      await DefaultAssetBundle.of(context)
          .loadString('assets/default_radio.txt'),
    );
    return ListView.builder(
      controller: _radioListScrollController,
      itemCount: defaultRadioLists.length,
      itemExtent: 60,
      itemBuilder: (context, index) => _buildAudioListTile(
        defaultRadioLists[index],
        ref,
      ),
    );
  }

  Widget _buildControlCard() {
    final player = ref.watch(playerProvider);
    final settings = ref.watch(settingsProvider);
    return Card(
      child: Column(
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
      ),
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
            child: Card(
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
          ),
          _buildControlCard(),
        ],
      );
}
