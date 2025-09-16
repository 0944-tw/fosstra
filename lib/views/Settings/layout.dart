import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tra/l10n/app_localizations.dart';

class SettingsLayout extends StatefulWidget {
  final Widget child;
  final String title;

  const SettingsLayout({super.key, required this.child,required this.title});

  @override
  State<SettingsLayout> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text(widget.title), leading: BackButton(onPressed: () => context.pop()), centerTitle: true),
      body: widget.child,
    );
  }
}
