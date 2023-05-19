import 'package:flutter/material.dart';

enum AppLocale implements Comparable<AppLocale> {
  english(locale: Locale(NamedLocale.localeEn), name: NamedLocale.nameEn),
  spanish(locale: Locale(NamedLocale.localeEs), name: NamedLocale.nameEs),
  japanese(locale: Locale(NamedLocale.localeJa), name: NamedLocale.nameJp);

  const AppLocale({
    required this.locale,
    required this.name,
  });

  final Locale locale;
  final String name;

  @override
  int compareTo(AppLocale other) => identityHashCode(other);
}

class NamedLocale {
  static const localeEn = 'en';
  static const localeEs = 'es';
  static const localeJa = 'ja';

  static const nameEn = 'English';
  static const nameEs = 'Español';
  static const nameJp = '日本語';
}
