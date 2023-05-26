import 'package:blue_retro/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class ActionSettings extends StatelessWidget {
  const ActionSettings({Key? key}) : super(key: key);

  void _goToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SettingsScreen(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _goToSettings(context),
      icon: const Icon(Icons.settings),
    );
  }
}
