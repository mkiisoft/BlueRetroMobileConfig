import 'package:blue_retro/l10n/app_localizations.dart';
import 'package:blue_retro/notifiers/app_notifier.dart';
import 'package:blue_retro/notifiers/main_notifier.dart';
import 'package:blue_retro/utils/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final BuildContext context;

  const SettingsScreen(this.context, {Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {

  void _setDarkMode(bool darkMode) {
    providerContainer.read(appNotifier.notifier).setDarkMode(darkMode);
  }

  void _setLanguage(Locale locale) {
    providerContainer.read(appNotifier.notifier).setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(appNotifier.notifier);
    print('REF: $ref');
    print('REF_DATA: ${provider.option.darkMode}');
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.toolbarSettingsTitle)),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(AppLocalizations.of(context)!.stringDarkMode),
            ),
            trailing: Switch(
              value: provider.option.darkMode,
              onChanged: _setDarkMode,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: DropdownButtonFormField<AppLocale>(
              value: AppLocale.values.firstWhere(
                (element) => element.locale == provider.option.language,
              ),
              items: AppLocale.values.map<DropdownMenuItem<AppLocale>>((item) {
                return DropdownMenuItem<AppLocale>(
                  value: item,
                  child: Text(item.name),
                );
              }).toList(),
              onChanged: (item) => _setLanguage(item!.locale),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(AppLocalizations.of(context)!.stringLanguage)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
