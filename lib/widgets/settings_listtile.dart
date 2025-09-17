import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final GestureTapCallback? onTap;
  final Widget? trailing;

  const SettingsListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(

      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
     // subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
      tileColor: Theme.of(context).colorScheme.surface,
      leading: icon != null
          ? Icon(
              icon,
              weight: 600,
              color: Theme.of(context).colorScheme.secondary,
            )
          : null,
    );
  }
}
