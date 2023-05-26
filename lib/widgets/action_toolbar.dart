import 'package:blue_retro/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ActionToolbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget action;
  final double height;
  final String? title;
  const ActionToolbar(this.action, {super.key, this.height = kToolbarHeight,
    this.title});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title ?? AppLocalizations.of(context)!.toolbarTitle),
      actions: [action],
    );
  }
}
