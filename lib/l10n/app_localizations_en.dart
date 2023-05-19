import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'BlueRetro';

  @override
  String get toolbarTitle => 'BlueRetro Config';

  @override
  String get buttonSearchDevices => 'Search for Devices';

  @override
  String get buttonSaveDevice => 'Save Device';

  @override
  String get toolbarSettingsTitle => 'Settings';

  @override
  String get stringLanguage => 'Language';

  @override
  String get stringDarkMode => 'Dark Mode';
}
