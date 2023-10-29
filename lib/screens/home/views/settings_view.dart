import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radio_beats/models/radio_model.dart';
import 'package:radio_beats/providers/radio_list_provider.dart';
import 'package:radio_beats/providers/settings_provider.dart';
import 'package:radio_beats/utils/card_container.dart';
import 'package:radio_beats/utils/platform.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final radioModel = ref.read(radioListProvider);

    Widget buildDefaultModelWidget(BuildContext context, WidgetRef ref) =>
        ListTile(
          title: const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text('Default radio'),
          ),
          trailing: SizedBox(
            width: 200,
            child: DropdownButton<RadioModel>(
              value: ref.watch(settingsProvider).defaultModel,
              isExpanded: true,
              items: radioModel
                  .mapIndexed(
                    (index, model) => DropdownMenuItem<RadioModel>(
                      value: model,
                      child: Text(
                        '${index.toString().padLeft(3, "0")} ${model.name}',
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: <RadioModel>(value) async {
                if (value == null) {
                  return;
                }
                // await ref
                //     .read(settingsProvider.notifier)
                //     .setDefaultModel(value);
              },
            ),
          ),
        );

    return Column(
      children: [
        Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardContainer(
                  children: [
                    buildDefaultModelWidget(context, ref),
                  ],
                ),
                if (isDesktop)
                  CardContainer(
                    children: [
                      ListTile(
                        title: const Text('Window in center'),
                        trailing: Switch(
                          value: ref.watch(settingsProvider).windowInCenter,
                          onChanged: (v) async {
                            await ref
                                .read(settingsProvider.notifier)
                                .setWindowInCenter(v);
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
