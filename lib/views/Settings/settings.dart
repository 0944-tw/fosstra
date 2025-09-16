import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:modern_dialog/modern_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/l10n/app_localizations.dart';
import 'package:tra/views/LocationSelect/location_select.dart';
import 'package:tra/views/Settings/settings_viewmodel.dart';
import 'package:tra/views/TRA_SearchPage/tra_searchpage.dart';
import 'package:tra/widgets/SettingsListTile.dart';

class SettingsIndex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const Map<String, String> languageMap = {
      'en': 'English',
      'es': 'Español', // Spanish
      'fr': 'Français', // French
      'de': 'Deutsch', // German
      'it': 'Italiano', // Italian
      'ja': '日本語', // Japanese
      'ko': '한국어', // Korean
      'zh': '中文', // Chinese
      'hi': 'हिन्दी', // Hindi
      'ar': 'العربية', // Arabic
      'pt': 'Português', // Portuguese
    };

    return ViewModelBuilder<SettingsViewModel>.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      onViewModelReady: (model) => model.init(context),
      builder: (context, model, child) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Text(
                localizations.settingsGeneral,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14.0,
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsListTile(
                    onTap: () {
                      model.setEnableMaterialYou(!model.enableMaterialYou);
                    },
                    icon: Symbols.brush_rounded,
                    title: localizations.settingsMaterialYouTitle,
                    subtitle: localizations.settingsMaterialYouDescription,
                    trailing: Switch(
                      // This bool value toggles the switch.
                      value: model.enableMaterialYou,
                      onChanged: (bool value) async {
                        model.setEnableMaterialYou(!model.enableMaterialYou);
                      },
                    ),
                  ),
                  SizedBox(height: 3),
                  SettingsListTile(
                    icon: Symbols.translate_rounded,
                    title: localizations.settingsLanguageTitle,
                    subtitle: languageMap[model.locale.languageCode]!,
                    onTap: () async {
                      await context.push("/settings/locale");
                      model.init(context);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Text(
                localizations.settingsAdvanced,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14.0,
                ),
              ),
            ),

            Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsListTile(
                    icon: Symbols.link,
                    title: localizations.settingsAPIConfigurationTitle,
                    subtitle: localizations.settingsAPIConfigurationDescription,
                    onTap: () {},
                  ),
                  SizedBox(height: 3),
                  SettingsListTile(
                    title: localizations.settingsDebugModeTitle,
                    subtitle: localizations.settingsDebugModeDescription,
                    icon: Symbols.bug_report_rounded,
                    onTap: () async {
                      await context.push("/settings/debug");
                    },
                    trailing: Switch(
                      // This bool value toggles the switch.
                      value: model.debugMode,
                      onChanged: (bool value) async {
                        model.setDebugMode(!model.debugMode);
                      },
                    ),
                  ),
                  SizedBox(height: 3),
                  SettingsListTile(
                    title: "Reset Data",
                    subtitle: "Something went wrong? Click here to reset data",
                    icon: Symbols.delete,
                    onTap: () {
                      model.resetData();
                    },
                  ),
                  SizedBox(height: 3),
                  SettingsListTile(
                    title: localizations.settingsTestingDataTitle,
                    subtitle: localizations.settingsTestingDataDescription,
                    icon: Symbols.data_object_rounded,
                    onTap: () {},
                    trailing: Switch(
                      // This bool value toggles the switch.
                      value: model.useTestData,
                      onChanged: (bool value) async {
                        model.setUseTestData(!model.useTestData);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Text(
                localizations.settingsAbout,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14.0,
                ),
              ),
            ),

            Material(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsListTile(
                    title: localizations.settingsVersionTitle,
                    subtitle: "v0.0.1-114514",
                    icon: Symbols.info_rounded,
                    onTap: () {},
                  ),
                  Divider(height: 1),

                  SettingsListTile(
                    title: localizations.settingsDonateTitle,
                    icon: Symbols.favorite_rounded,
                    subtitle: localizations.settingsDonateDescription,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: 3),
          ],
        ),
      ),
    );
  }
}
