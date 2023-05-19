import 'package:blue_retro/l10n/app_localizations.dart';
import 'package:blue_retro/notifiers/ble_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeToolbar extends ConsumerWidget {
  final ChangeNotifierProvider<BleNotifier> provider;
  const HomeToolbar(this.provider, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.localeName),
      actions: const [SizedBox()],
    );
  }
}
