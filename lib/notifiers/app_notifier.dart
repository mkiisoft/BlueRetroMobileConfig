import 'package:blue_retro/model/option.dart';
import 'package:blue_retro/utils/shared_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppNotifier extends ChangeNotifier {
  final _shared = SharedUtils();
  Option option = Option.getDefault();

  void setOption(Option option) {
    this.option = option;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    option.language = locale;
    _shared.setOption(option);
    notifyListeners();
  }

  void setDarkMode(bool darkMode) {
    option.darkMode = darkMode;
    _shared.setOption(option);
    notifyListeners();
  }
}

final appNotifier = ChangeNotifierProvider((ref) => AppNotifier());
final providerContainer = ProviderContainer();
