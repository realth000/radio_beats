import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/radio_model.dart';
import '../../../services/player_service.dart';

class RadioView extends ConsumerWidget {
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

  ListTile _buildAudioListTile(RadioModel radioModel, WidgetRef ref) =>
      ListTile(
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
            // TODO: Reduce these too many refs.
            print('AAAA call onSelected');
            switch (value) {
              case 0:
                ref.watch(playerServiceProvider.notifier).state.currentRadio =
                    radioModel;
                await ref
                    .watch(playerServiceProvider.notifier)
                    .state
                    .play(radioModel);
                return;
              case 1:
                await Clipboard.setData(ClipboardData(text: radioModel.url));
                return;
            }
          },
        ),
      );

  Future<Widget> _buildRadioList(BuildContext context, WidgetRef ref) async {
    final defaultRadioLists = _buildDefaultRadioList(
      await DefaultAssetBundle.of(context)
          .loadString('assets/default_radio.txt'),
    );
    return ListView.builder(
      itemCount: defaultRadioLists.length,
      itemExtent: 60,
      itemBuilder: (context, index) => _buildAudioListTile(
        defaultRadioLists[index],
        ref,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
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
          Card(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final r = ref
                            .watch(playerServiceProvider.notifier)
                            .state
                            .currentRadio;
                        if (r == null) {
                          return;
                        }
                        await ref
                            .watch(playerServiceProvider.notifier)
                            .state
                            .play(r);
                      },
                      child: const Icon(Icons.play_arrow),
                    ),
                    const SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async => ref
                          .watch(playerServiceProvider.notifier)
                          .state
                          .stop(),
                      child: const Icon(Icons.stop),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      );
}
