import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/radio_model.dart';
import '../../../provider/radio_list_provider.dart';
import '../../../provider/settings_provider.dart';
import '../../../utils/platform.dart';

class SettingsView extends ConsumerStatefulWidget {
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
          title: Text('Default radio'),
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
                await ref
                    .read(settingsProvider.notifier)
                    .setDefaultModel(value);
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
                buildDefaultModelWidget(context, ref),
                if (isDesktop)
                  Card(
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Window in center'),
                          value: ref.watch(settingsProvider).windowInCenter,
                          onChanged: (v) async {
                            await ref
                                .read(settingsProvider.notifier)
                                .setWindowInCenter(v);
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
