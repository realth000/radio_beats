import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radio_beats/providers/player_provider.dart';
import 'package:radio_beats/providers/settings_provider.dart';

part '../generated/models/radio_model.freezed.dart';
part '../generated/models/radio_model.g.dart';

/// RadioModel contains a radio target.
///
/// Including radio name, radio url with optional radio style, radio language,
/// and radio sample rate.
@freezed
class RadioModel with _$RadioModel {
  /// Constructor
  const factory RadioModel({
    /// Radio name to display.
    required String name,

    /// Radio url to fetch music stream.
    required String url,

    /// Music style, can be null.
    String? style,

    /// Music language (code), can be null.
    String? language,

    /// Radio samplerate, can be null.
    int? sampleRate,
  }) = _RadioModel;

  /// Build from json.
  factory RadioModel.fromJson(Map<String, Object?> json) =>
      _$RadioModelFromJson(json);
}

enum _RadioListTileAction {
  play,
  copyUrl,
  addToFavorite,
  removeFromFavorite,
}

extension BuildRadioListTile on RadioModel {
  ListTile buildRadioListTile(WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final favoriteRadioList = ref.watch(settingsProvider).favoriteRadioList;
    final bool isFavorite;
    if (favoriteRadioList.firstWhereOrNull((e) => e == name) != null) {
      isFavorite = true;
    } else {
      isFavorite = false;
    }
    return ListTile(
      horizontalTitleGap: 10,
      leading: Text(
        language ?? '',
        maxLines: 1,
        style: const TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w600,
        ),
      ),
      title: Text(name, maxLines: 1),
      subtitle: Text(
        url,
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) => <PopupMenuItem<_RadioListTileAction>>[
          const PopupMenuItem(
            value: _RadioListTileAction.play,
            child: Row(
              children: [Icon(Icons.play_arrow), Text('Play')],
            ),
          ),
          const PopupMenuItem(
            value: _RadioListTileAction.copyUrl,
            child: Row(
              children: [Icon(Icons.copy), Text('Copy Url')],
            ),
          ),
          if (!isFavorite)
            const PopupMenuItem(
              value: _RadioListTileAction.addToFavorite,
              child: Row(
                children: [Icon(Icons.favorite_outline), Text('Add Favorite')],
              ),
            ),
          if (isFavorite)
            const PopupMenuItem(
              value: _RadioListTileAction.removeFromFavorite,
              child: Row(
                children: [
                  Icon(Icons.favorite_outlined),
                  Text('Remove Favorite')
                ],
              ),
            ),
        ],
        onSelected: (value) async {
          switch (value) {
            case _RadioListTileAction.play:
              player.currentRadio = this;
              await ref.read(playerProvider.notifier).play(this);
            case _RadioListTileAction.copyUrl:
              await Clipboard.setData(ClipboardData(text: url));
            case _RadioListTileAction.addToFavorite:
              await ref.read(settingsProvider.notifier).addFavoriteRadio(this);
            case _RadioListTileAction.removeFromFavorite:
              await ref
                  .read(settingsProvider.notifier)
                  .removeFavoriteRadio(this);
          }
        },
      ),
    );
  }
}
