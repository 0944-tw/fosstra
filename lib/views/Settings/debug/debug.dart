import 'package:flutter/material.dart';

class SettingsDebugPage extends StatelessWidget {
  const SettingsDebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),

      child: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text("Color Scheme", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Center(
                    child: Column(
                      children: [
                        Text('Primary ${color.primary}'),
                        Text('Primary Fixed ${color.primaryFixed} ${color.primaryFixed == color.primary}'),
                        Text('Primary Fixed Dim  ${color.primaryFixedDim} ${color.primaryFixedDim == color.primary}'),
                        Text('Surface  ${color.surface}'),
                        Text('Surface Container  ${color.surfaceContainer} ${color.surfaceContainer == color.surface}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
