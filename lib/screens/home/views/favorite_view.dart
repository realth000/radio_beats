import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radio_beats/models/radio_model.dart';
import 'package:radio_beats/providers/radio_list_provider.dart';
import 'package:radio_beats/providers/settings_provider.dart';

class FavoriteView extends ConsumerStatefulWidget {
  const FavoriteView({super.key});

  @override
  ConsumerState<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends ConsumerState<FavoriteView> {
  @override
  Widget build(BuildContext context) {
    final allRadioList = ref.watch(radioListProvider);
    final favoriteRadioList = ref.watch(settingsProvider).favoriteRadioList;

    if (favoriteRadioList.isEmpty) {
      return Center(
        child: Text(
          'Nothing To Show',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      );
    }

    return ListView.builder(
      itemCount: favoriteRadioList.length,
      itemBuilder: (context, index) {
        final model = allRadioList
            .firstWhereOrNull((e) => e.name == favoriteRadioList[index]);
        if (model == null) {
          return const ListTile(title: Text('model not found'));
        }
        return model.buildRadioListTile(ref);
      },
    );
  }
}
