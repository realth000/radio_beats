import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/radio_model.dart';

/// Global radio list provider.
final radioListProvider = StateProvider((ref) => _radioList);

final _radioList = <RadioModel>[];

/// Load radio model list.
Future<void> initRadioModelList() async {
  _radioList.addAll(
    _buildDefaultRadioList(
      await rootBundle.loadString('assets/default_radio.txt'),
    ),
  );
}

List<RadioModel> _buildDefaultRadioList(String str) {
  final modelList = <RadioModel>[];
  str.split('\n').forEach((s) {
    final ss = s.split('|');
    if (ss.length != 6) {
      return;
    }
    modelList.add(
      RadioModel(
        name: ss[1],
        url: ss[0],
        style: ss[2],
        language: ss[3],
        sampleRate: int.parse(ss[4]),
      ),
    );
  });
  return modelList;
}
