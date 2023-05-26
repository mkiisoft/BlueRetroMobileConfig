import 'app_localizations.dart';

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'BlueRetro';

  @override
  String get toolbarTitle => 'BlueRetro Config';

  @override
  String get buttonSearchDevices => 'デバイスの検索';

  @override
  String get buttonSaveDevice => 'デバイスを保存';

  @override
  String get toolbarSettingsTitle => '設定';

  @override
  String get stringLanguage => '言語';

  @override
  String get stringDarkMode => 'ダークモード';
}
