import 'package:blue_retro/l10n/app_localizations.dart';
import 'package:blue_retro/notifiers/app_notifier.dart';
import 'package:blue_retro/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: providerContainer,
      child: Consumer(
        builder: (context, ref, child) {
          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
            theme: ThemeData(
              useMaterial3: true,
              brightness: ref.watch(appNotifier).option.darkMode
                  ? Brightness.dark
                  : Brightness.light,
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            locale: ref.watch(appNotifier).option.language,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Splash(),
          );
        },
      ),
    );
  }
}
