import 'package:blue_retro/utils/app_locale.dart';
import 'package:flutter/material.dart';

class Option {
  Locale language = AppLocale.english.locale;
  bool darkMode = WidgetsBinding.instance.platformDispatcher
      .platformBrightness == Brightness.dark;

  Option._({
    required this.language,
    required this.darkMode,
  });

  factory Option.getDefault() {
    return Option._(
      language: AppLocale.english.locale,
      darkMode: WidgetsBinding.instance.platformDispatcher
          .platformBrightness == Brightness.dark,
    );
  }

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option._(
      language: Locale(json['language']),
      darkMode: json['darkMode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language.languageCode,
      'darkMode': darkMode,
    };
  }
}
